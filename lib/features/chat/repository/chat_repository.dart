import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/models/chat.dart';
import 'package:whatsup/common/models/group.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/repositories/auth.dart';
import 'package:whatsup/common/repositories/storage.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/logger.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
    user: ref.read(userRepositoryProvider),
    auth: ref.read(authRepositoryProvider),
    storage: ref.read(storageRepositoryProvider),
  );
}, name: (ChatRepository).toString());

class ChatRepository {
  final UserRepository _db;
  final AuthRepository _auth;
  final StorageRepository _storage;
  final Logger _logger = AppLogger.getLogger((ChatRepository).toString());

  ChatRepository({
    required UserRepository user,
    required AuthRepository auth,
    required StorageRepository storage,
  })  : _db = user,
        _auth = auth,
        _storage = storage;

  Future<void> markMessageAsSeen({
    required String receiverId,
    required String messageId,
  }) async {
    try {
      final userId = _auth.currentUser.unwrap().uid;
      await _db.chatMessages(userId: userId, chatId: receiverId).doc(messageId).update({
        'isRead': true,
      });
      await _db.chatMessages(userId: receiverId, chatId: userId).doc(messageId).update({
        'isRead': true,
      });
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<void> saveMessage({
    required String id,
    required UserModel sender,
    required Option<UserModel> receiver,
    required String receiverId,
    required String text,
    required DateTime time,
    required MessageType type,
    required Option<MessageReply> reply,
    required bool isGroup,
  }) async {
    final newMsg = MessageModel(
      uid: id,
      senderUsername: sender.name,
      senderId: sender.uid,
      senderProfileImage: sender.profileImage,
      recvId: receiverId,
      message: text,
      type: type,
      timeSent: time,
      isRead: false,
      repliedMessage: reply.isNone() ? '' : reply.unwrap().message,
      repliedTo: reply.isNone()
          ? ''
          : reply.unwrap().isSenderMessage
              ? sender.name
              : receiver.isNone()
                  ? ''
                  : receiver.unwrap().name,
      repliedMessageType: reply.isNone() ? MessageType.text : reply.unwrap().type,
    );
    if (isGroup) {
      await _db.groups
          .doc(receiverId)
          .collection(kChatsSubCollectionId)
          .doc(id)
          .set(newMsg.toMap());
    } else {
      await _db.chatMessages(userId: sender.uid, chatId: receiverId).doc(id).set(newMsg);
      await _db.chatMessages(userId: receiverId, chatId: sender.uid).doc(id).set(newMsg);
    }
  }

  Future<void> updateChat({
    required UserModel sender,
    required Option<UserModel> receiver,
    required String receiverId,
    required DateTime messageTime,
    required String message,
    required bool isGroup,
  }) async {
    // First we update the chat of the receiver
    final activeUser = _auth.currentUser;
    final userId = activeUser.unwrap().uid; // assuming that the user is logged in

    if (isGroup) {
      _db.groups.doc(receiverId).update({
        'lastMessageTime': messageTime.microsecondsSinceEpoch,
        'lastMessage': message,
      });
    } else {
      final receiverChat = ChatModel(
        name: sender.name,
        profileImage: sender.profileImage,
        receiverId: sender.uid,
        lastMessageTime: messageTime,
        lastMessage: message,
      );
      final receiverData = receiver.unwrap();
      await _db.userChats(receiverId).doc(userId).set(receiverChat);

      // Then we update the chat of the sender
      final senderChat = ChatModel(
        name: receiverData.name,
        profileImage: receiverData.profileImage,
        receiverId: receiverData.uid,
        lastMessageTime: messageTime,
        lastMessage: message,
      );
      await _db.userChats(userId).doc(receiverId).set(senderChat);
    }
  }

  Future<void> sendFileMessage({
    required File file,
    required String receiverId,
    required UserModel sender,
    required Ref ref,
    required MessageType type,
    required Option<MessageReply> reply,
    required bool isGroup,
  }) async {
    try {
      final time = DateTime.now();
      final messageId = const Uuid().v4();

      String url = await _storage.uploadFile(
        path: 'chat/${type.type}/${sender.uid}/$receiverId/${time.millisecondsSinceEpoch}',
        file: file,
      );
      Option<UserModel> recvUser = none();
      if (!isGroup) {
        final recvQuery = await _db.users.doc(receiverId).get();
        final receiver = recvQuery.data();
        if (receiver == null) {
          _logger.e("Receiver not found. Chat could not be updated.");
          return;
        }
        recvUser = some(receiver);
      }

      String message;
      switch (type) {
        case MessageType.image:
          message = '📷 Photo';
          break;
        case MessageType.video:
          message = '📸 Video';
          break;
        case MessageType.audio:
          message = '🎵 Audio';
          break;
        case MessageType.gif:
          message = 'GIF';
          break;
        default:
          message = 'GIF';
      }

      updateChat(
        sender: sender,
        receiver: recvUser,
        receiverId: receiverId,
        messageTime: time,
        message: message,
        isGroup: isGroup,
      );

      saveMessage(
        id: messageId,
        sender: sender,
        receiver: recvUser,
        receiverId: receiverId,
        text: url,
        time: time,
        type: type,
        reply: reply,
        isGroup: isGroup,
      );
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<void> sendTextMessage({
    required UserModel sender,
    required String receiverId,
    required String message,
    required Option<MessageReply> reply,
    required bool isGroup,
  }) async {
    try {
      _logger.d("Sending message to $receiverId");
      final time = DateTime.now();
      final messageId = const Uuid().v4();
      // empty when sending to a group
      Option<UserModel> receiver = none();
      if (!isGroup) {
        final receiverQuery = await _db.users.doc(receiverId).get();
        final recv = receiverQuery.data();
        if (recv == null) {
          _logger.e("Receiver not found. Chat could not be updated.");
          return;
        }
        receiver = some(recv);
      }

      updateChat(
        sender: sender,
        receiver: receiver,
        receiverId: receiverId,
        messageTime: time,
        message: message,
        isGroup: isGroup,
      );
      saveMessage(
          id: messageId,
          sender: sender,
          receiver: receiver,
          receiverId: receiverId,
          text: message,
          time: time,
          type: MessageType.text,
          reply: reply,
          isGroup: isGroup);
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Stream<List<GroupModel>> get userGroups {
    return _auth.currentUser.match(
      () => const Stream.empty(),
      (userModel) {
        return _db.groups.snapshots().map((event) {
          return event.docs
              .map((e) => e.data())
              .filter((group) => group.members.contains(userModel.uid))
              .toList();
        });
      },
    );
  }

  Stream<List<ChatModel>> get chats {
    return _auth.currentUser.match(
      () => const Stream.empty(),
      (userModel) {
        return _db.userChats(userModel.uid).snapshots().map((event) {
          return event.docs.map((e) {
            return e.data();
          }).toList();
        });
      },
    );
  }

  Stream<List<MessageModel>> getGroupMessages(String groupId) {
    return _db.groups
        .doc(groupId)
        .collection(kChatsSubCollectionId)
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      return event.docs.map((e) => MessageModel.fromMap(e.data())).toList();
    });
  }

  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _auth.currentUser.match(
      () {
        _logger.d("User not logged in");
        return const Stream.empty();
      },
      (userModel) {
        return _db
            .chatMessages(userId: userModel.uid, chatId: chatId)
            .orderBy('timeSent')
            .snapshots()
            .map((event) {
          return event.docs.map((e) => e.data()).toList();
        });
      },
    );
  }
}

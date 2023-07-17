import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/models/chat.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/repositories/auth.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/logger.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
    user: ref.read(userRepositoryProvider),
    auth: ref.read(authRepositoryProvider),
  );
}, name: (ChatRepository).toString());

class ChatRepository {
  final UserRepository _db;
  final AuthRepository _auth;
  final Logger _logger = AppLogger.getLogger((ChatRepository).toString());

  ChatRepository({
    required UserRepository user,
    required AuthRepository auth,
  })  : _db = user,
        _auth = auth;

  Future<void> saveMessage({
    required String id,
    required UserModel sender,
    required UserModel receiver,
    required String text,
    required DateTime time,
    required ChatMessageType type,
  }) async {
    final newMsg = MessageModel(
      uid: id,
      senderId: sender.uid,
      recvId: receiver.uid,
      message: text,
      type: type,
      timeSent: time,
      isRead: false,
    );

    await _db.chatMessages(userId: sender.uid, chatId: receiver.uid).doc(id).set(newMsg);
    await _db.chatMessages(userId: receiver.uid, chatId: sender.uid).doc(id).set(newMsg);
  }

  Future<void> updateChat({
    required UserModel sender,
    required UserModel receiver,
    required String messageReceiverId,
    required DateTime messageTime,
    required String message,
  }) async {
    // First we update the chat of the receiver
    final activeUser = _auth.currentUser;
    final userId = activeUser.unwrap().uid; // assuming that the user is logged in

    final receiverChat = ChatModel(
      name: sender.name,
      profileImage: sender.profileImage,
      receiverId: sender.uid,
      lastMessageTime: messageTime,
      lastMessage: message,
    );

    await _db.userChats(messageReceiverId).doc(userId).set(receiverChat);

    // Then we update the chat of the sender
    final senderChat = ChatModel(
      name: receiver.name,
      profileImage: receiver.profileImage,
      receiverId: receiver.uid,
      lastMessageTime: messageTime,
      lastMessage: message,
    );
    await _db.userChats(userId).doc(messageReceiverId).set(senderChat);
  }

  Future<void> sendMessage({
    required UserModel sender,
    required String receiverId,
    required String message,
  }) async {
    try {
      _logger.d("Sending message to $receiverId");
      final time = DateTime.now();
      final messageId = const Uuid().v4();
      final receiverQuery = await _db.users.doc(receiverId).get();
      final receiver = receiverQuery.data();
      if (receiver == null) {
        _logger.e("Receiver not found. Chat could not be updated.");
        return;
      }
      updateChat(
        sender: sender,
        receiver: receiver,
        messageReceiverId: receiver.uid,
        messageTime: time,
        message: message,
      );
      saveMessage(
        id: messageId,
        sender: sender,
        receiver: receiver,
        text: message,
        time: time,
        type: ChatMessageType.text,
      );
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Stream<List<ChatModel>> get chats {
    return _auth.currentUser.match(
      () => const Stream.empty(),
      (userModel) {
        return _db.userChats(userModel.uid).snapshots().map((event) {
          return event.docs.map((e) {
            _logger.d("Receiver: ${e.data().receiverId}");
            return e.data();
          }).toList();
        });
      },
    );
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

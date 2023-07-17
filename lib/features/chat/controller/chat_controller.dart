import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/features/chat/repository/chat_repository.dart';

final chatControllerRepository = Provider((ref) {
  return ChatController(
    chatRepository: ref.read(chatRepositoryProvider),
    ref: ref,
  );
});

final chatsStreamProvider = StreamProvider((ref) {
  return ref.watch(chatRepositoryProvider).chats;
});

final messagesStreamProvider = StreamProvider.family((ref, String chatId) {
  return ref.watch(chatRepositoryProvider).getChatMessages(chatId);
});

class ChatController {
  final ChatRepository chatRepository;
  final Ref ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendText({
    required BuildContext context,
    required String text,
    required String receiverId,
  }) {
    ref.read(userFetchProvider).whenData((value) {
      if (value.isSome()) {
        chatRepository.sendMessage(
          sender: value.unwrap(),
          receiverId: receiverId,
          message: text,
        );
      }
    });
  }
}

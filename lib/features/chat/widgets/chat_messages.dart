// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/auth/controllers/auth.dart';
import 'package:whatsup/features/chat/controller/chat_controller.dart';
import 'package:whatsup/features/chat/widgets/message_card.dart';

class ChatMessages extends ConsumerStatefulWidget {
  final String receiverId;
  final String receiverName;
  final bool isGroup;
  const ChatMessages({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.isGroup,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<ChatMessages> {
  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scroll.dispose();
  }

  void onMessageSwipe(String msg, bool isMyMessage, ChatMessageType replyType, String to) {
    ref.read(messageReplyProvider.notifier).update((state) => Some(
          MessageReply(
            repliedTo: to,
            message: msg,
            isSenderMessage: isMyMessage,
            type: replyType,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final liveStream = widget.isGroup
        ? ref.watch(groupMessagesStreamProvider(widget.receiverId))
        : ref.watch(messagesStreamProvider(widget.receiverId));

    return liveStream.when(
      data: (messages) {
        if (messages.isEmpty) {
          return const Center(
            child: Text('No messages sent'),
          );
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          scroll.animateTo(
            scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastEaseInToSlowEaseOut,
          );
        });
        return ListView.builder(
          controller: scroll,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            tryMarkMessageAsSeen(message);

            final isMyMessage =
                message.senderId == ref.read(authControllerProvider).currentUser.unwrap().uid;
            return MessageCard(
              actor: isMyMessage ? Actor.sender : Actor.receiver,
              model: message,
              onRightSwipe: () => onMessageSwipe(
                message.message,
                isMyMessage,
                message.type,
                widget.receiverName,
              ),
            );
          },
        );
      },
      error: (err, trace) => UnhandledError(
        error: err.toString(),
      ),
      loading: () => const WorkProgressIndicator(),
    );
  }

  void tryMarkMessageAsSeen(MessageModel message) {
    final activeUser = ref.read(authControllerProvider).currentUser.unwrap().uid;
    if (!message.isRead && message.recvId == activeUser) {
      ref.read(chatControllerProvider).markMessageAsSeen(
            receiverId: widget.receiverId,
            messageId: message.uid,
          );
    }
  }
}

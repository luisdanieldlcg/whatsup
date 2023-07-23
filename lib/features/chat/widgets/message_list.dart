import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/auth/controllers/auth.dart';
import 'package:whatsup/features/chat/controller/chat_controller.dart';
import 'package:whatsup/features/chat/widgets/chat_bubble.dart';
import 'package:whatsup/features/chat/widgets/chat_time_bubble.dart';

class MessageList extends ConsumerStatefulWidget {
  final String receiverId;
  final String receiverName;
  final bool isGroup;
  const MessageList({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.isGroup,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<MessageList> {
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

  @override
  Widget build(BuildContext context) {
    final liveStream = widget.isGroup
        ? ref.watch(groupMessagesStreamProvider(widget.receiverId))
        : ref.watch(messagesStreamProvider(widget.receiverId));
    final userId = getUserId(ref);
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
            tryMarkMessageAsSeen(userId, message);
            final repeatedSender = index > 0 && messages[index - 1].senderId == message.senderId;
            final isMyMessage = message.senderId == userId;
            final sentAt = message.timeSent;
            final shouldSentTime =
                index == 0 || sentAt.difference(messages[index - 1].timeSent).inDays > 0;
            final isMostRecent = index == messages.length - 1;

            return Column(
              children: [
                if (shouldSentTime) ...{
                  ChatTimeBubble(time: sentAt),
                },
                ChatBubble(
                  repeatedSender: repeatedSender,
                  isSenderMessage: isMyMessage,
                  isMostRecent: isMostRecent,
                  model: message,
                  receiverName: widget.receiverName,
                ),
              ],
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

  void tryMarkMessageAsSeen(String userId, MessageModel message) {
    if (!message.isRead && message.recvId == userId) {
      ref.read(chatControllerProvider).markMessageAsSeen(
            receiverId: widget.receiverId,
            messageId: message.uid,
          );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/chat/controller/chat_controller.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_bubble.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_image_bubble.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_time_bubble.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_audio_bubble.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_video_bubble.dart';

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
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
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
            final repeatedSender = index > 0 && messages[index - 1].senderId == message.senderId;
            final isMyMessage = message.senderId == userId;
            final sentAt = message.timeSent;
            final shouldRenderTime =
                index == 0 || sentAt.difference(messages[index - 1].timeSent).inDays > 0;
            final isMostRecent = index == messages.length - 1;
            if (message.type != MessageType.audio) {
              markMessageAsSeen(userId, message);
            }
            return Column(
              children: [
                if (shouldRenderTime) ...{
                  ChatTimeBubble(time: sentAt),
                },
                switch (message.type) {
                  MessageType.audio => ChatAudioBubble(
                      isGroup: widget.isGroup,
                      message: message,
                      isMostRecent: isMostRecent,
                      receiverName: widget.receiverName,
                      repeatedSender: repeatedSender,
                      isDark: isDark,
                      isMyMessage: isMyMessage,
                      onAudioStarted: () {
                        if (!message.isRead) {
                          markMessageAsSeen(userId, message);
                        }
                      },
                    ),
                  MessageType.image => ChatImageBubble(
                      model: message,
                      isDark: isDark,
                      isMessageSender: isMyMessage,
                      receiverName: widget.receiverName,
                    ),
                  MessageType.video => ChatVideoBubble(
                      model: message,
                      isGroup: widget.isGroup,
                      isSenderMessage: isMyMessage,
                      isMostRecentMessage: isMostRecent,
                      receiverName: widget.receiverName,
                      isRepeatedSender: repeatedSender,
                      src: VideoDataSource.network,
                    ),
                  _ => ChatBubble(
                      isGroup: widget.isGroup,
                      repeatedSender: repeatedSender,
                      isSenderMessage: isMyMessage,
                      isMostRecent: isMostRecent,
                      model: message,
                      receiverName: widget.receiverName,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(message.message),
                      ),
                    ),
                },
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

  void markMessageAsSeen(String userId, MessageModel message) {
    if (!message.isRead && message.recvId == userId) {
      ref.read(chatControllerProvider).markMessageAsSeen(
            receiverId: widget.receiverId,
            messageId: message.uid,
          );
    }
  }
}

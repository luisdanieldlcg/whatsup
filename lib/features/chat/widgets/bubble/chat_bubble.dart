// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_bubble_bottom.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_reply_bubble.dart';

class ChatBubble extends ConsumerWidget {
  final bool isSenderMessage;
  final MessageModel model;
  final bool repeatedSender;
  final bool isMostRecent;
  final String receiverName;
  final Widget? child;
  final String audioLabel;
  final bool isGroup;
  const ChatBubble({
    Key? key,
    required this.isSenderMessage,
    required this.model,
    required this.repeatedSender,
    required this.isMostRecent,
    required this.receiverName,
    this.child,
    this.audioLabel = '',
    required this.isGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkEnabled = ref.watch(themeNotifierProvider) == Brightness.dark;

    final darkBubbleColor = isSenderMessage ? kSenderMessageColorDark : kReceiverMessageColorDark;
    final lightBubbleColor = isSenderMessage ? kSenderMessageColorLight : Colors.white;
    final alignment = isSenderMessage ? Alignment.topRight : Alignment.topLeft;
    final nip = isSenderMessage ? BubbleNip.rightTop : BubbleNip.leftTop;
    final double bottomMargin = isMostRecent ? 10 : 0;
    final double topMargin = repeatedSender ? 5 : 10;
    final margin = isSenderMessage
        ? BubbleEdges.only(top: topMargin, left: 50, right: 10, bottom: bottomMargin)
        : BubbleEdges.only(top: topMargin, right: 50, left: 10, bottom: bottomMargin);
    final showNip = !repeatedSender;
    return SwipeTo(
      offsetDx: 0.16,
      onRightSwipe: () => makeReply(ref),
      animationDuration: const Duration(milliseconds: 85),
      child: Bubble(
        margin: margin,
        alignment: alignment,
        radius: const Radius.circular(12),
        padding: const BubbleEdges.only(left: 8, right: 8, top: 3, bottom: 6),
        nip: nip,
        showNip: showNip,
        borderWidth: 0.7,
        borderColor: isDarkEnabled ? Colors.grey.shade800 : Colors.grey.shade400,
        color: isDarkEnabled ? darkBubbleColor : lightBubbleColor,
        borderUp: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            minWidth: 75,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (isGroup) ...{
                      const SizedBox(height: 4),
                      Text(
                        '~ ${model.senderUsername}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkEnabled ? Colors.white : Colors.black,
                        ),
                      ),
                    },
                    if (model.repliedMessage.isNotEmpty) ...{
                      // if this is a reply we want to show the message we are replying to
                      // in a opaqued card like whatsapp does
                      ChatReplyBubble(
                        isDarkEnabled: isDarkEnabled,
                        model: model,
                      )
                    } else ...{
                      // ignore child if this is a reply
                      child ?? const SizedBox.shrink(),
                    },
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: ChatBubbleBottom(
                  model: model,
                  isDark: isDarkEnabled,
                  audioLabel: audioLabel,
                  isReply: model.repliedMessage.isNotEmpty,
                  isAudio: model.type == MessageType.audio,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void makeReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => Some(
          MessageReply(
            repliedTo: receiverName,
            message: model.message,
            isSenderMessage: isSenderMessage,
            type: model.repliedMessageType,
          ),
        ));
  }
}

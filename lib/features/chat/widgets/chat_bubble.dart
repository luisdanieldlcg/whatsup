import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/features/chat/widgets/message_display.dart';

class ChatBubble extends ConsumerWidget {
  final bool isSenderMessage;
  final MessageModel model;
  final bool repeatedSender;
  final String receiverName;
  const ChatBubble({
    Key? key,
    required this.isSenderMessage,
    required this.model,
    required this.repeatedSender,
    required this.receiverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkEnabled = ref.watch(themeNotifierProvider) == Brightness.dark;

    final darkBubbleColor = isSenderMessage ? kSenderMessageColorDark : kReceiverMessageColorDark;
    final lightBubbleColor = isSenderMessage ? kSenderMessageColorLight : Colors.white;
    final alignment = isSenderMessage ? Alignment.topRight : Alignment.topLeft;
    final nip = isSenderMessage ? BubbleNip.rightTop : BubbleNip.leftTop;
    final double bottomMargin = repeatedSender ? 0 : 4;
    final double topMargin = repeatedSender ? 4 : 10;
    final margin = isSenderMessage
        ? BubbleEdges.only(top: topMargin, left: 50, right: 10, bottom: bottomMargin)
        : BubbleEdges.only(top: topMargin, right: 50, left: 10, bottom: bottomMargin);
    final showNip = !repeatedSender;
    return SwipeTo(
      offsetDx: 0.15,
      onRightSwipe: () => makeReply(ref),
      animationDuration: const Duration(milliseconds: 85),
      child: Bubble(
        margin: margin,
        alignment: alignment,
        radius: const Radius.circular(12),
        padding: const BubbleEdges.only(left: 12, right: 10, top: 8, bottom: 3),
        nip: nip,
        showNip: showNip,
        borderWidth: 0.7,
        borderColor: isDarkEnabled ? Colors.grey.shade800 : Colors.grey.shade400,
        color: isDarkEnabled ? darkBubbleColor : lightBubbleColor,
        borderUp: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MessageDisplay(
              type: model.type,
              message: model.message,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.Hm().format(model.timeSent),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkEnabled ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 5),
                if (model.isRead) ...{
                  const SizedBox(height: 5),
                  const Icon(
                    Icons.done_all,
                    size: 18,
                    color: Colors.blue,
                  ),
                } else ...{
                  const SizedBox(height: 5),
                  const Icon(
                    Icons.check,
                    size: 18,
                    color: Colors.grey,
                  ),
                }
              ],
            )
          ],
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

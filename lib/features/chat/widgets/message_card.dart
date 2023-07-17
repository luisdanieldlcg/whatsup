import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/features/chat/widgets/message_display.dart';

enum Actor {
  sender,
  receiver,
}

class MessageCard extends StatelessWidget {
  final Actor actor;
  final MessageModel model;
  final VoidCallback onRightSwipe;

  const MessageCard({
    super.key,
    required this.actor,
    required this.model,
    required this.onRightSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      animationDuration: const Duration(milliseconds: 85),
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: actor == Actor.sender ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.70,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: actor == Actor.sender ? kSenderMessageColor : kReceiverMessageColor,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 3),
              title: messageContent,
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (model.repliedMessage.isNotEmpty) ...{
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 8, bottom: 4),
                      child: Text(model.message),
                    ),
                    const Spacer(),
                  },
                  Text(
                    DateFormat.Hm().format(model.timeSent),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    model.isRead ? Icons.done_all : Icons.done,
                    size: 20,
                    color: model.isRead ? Colors.blue : Colors.white60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get messageContent {
    final isReply = model.repliedMessage.isNotEmpty;
    if (isReply) {
      return SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.only(top: 6, bottom: 12, left: 12, right: 0),
          decoration: BoxDecoration(
            color: kReplyMessageColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    model.repliedTo,
                    style: const TextStyle(color: kPrimaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                model.repliedMessage,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: messagePadding,
      child: MessageDisplay(
        type: model.type,
        message: model.message,
      ),
    );
  }

  EdgeInsets get messagePadding {
    if (model.type == ChatMessageType.text) {
      return EdgeInsets.zero;
    }
    return const EdgeInsets.only(
      left: 0.0,
      top: 10,
      right: 0,
      bottom: 1,
    );
  }
}

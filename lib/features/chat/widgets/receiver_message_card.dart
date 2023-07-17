import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/features/chat/widgets/message_display.dart';

class ReceiverMessageCard extends StatelessWidget {
  final MessageModel message;
  const ReceiverMessageCard({
    super.key,
    required this.message,
  });
  EdgeInsets get messagePadding {
    if (message.type == ChatMessageType.text) {
      return EdgeInsets.zero;
    }
    return const EdgeInsets.only(
      left: 0.0,
      top: 10,
      right: 0,
      bottom: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Card(
          elevation: 1,
          color: receiverMessageColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: ListTile(
            title: Padding(
              padding: messagePadding,
              child: MessageDisplay(type: message.type, message: message.message),
            ),
            // add date time
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat.Hm().format(message.timeSent),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 20,
                    color: message.isRead ? Colors.blue : Colors.white60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

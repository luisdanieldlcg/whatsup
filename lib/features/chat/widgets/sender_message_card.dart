import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/theme.dart';

class SenderMessageCard extends StatelessWidget {
  final MessageModel message;
  const SenderMessageCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Card(
          elevation: 1,
          color: senderMessageColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: ListTile(
            title: Text(message.message),
            // add date time
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
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
          // child: Stack(
          //   children: [
          //     ListTile(
          //       title: Text(message.message),
          //     ),
          //     Positioned(
          //       bottom: 0,
          //       right: 10,
          //       child: Row(
          //         children: [
          //           Text(
          //             message.timeSent.toString(),
          //             style: const TextStyle(
          //               fontSize: 13,
          //               color: Colors.white60,
          //             ),
          //           ),
          //           const SizedBox(
          //             width: 5,
          //           ),
          //           Icon(
          //             message.isRead ? Icons.done_all : Icons.done,
          //             size: 20,
          //             color: message.isRead ? Colors.blue : Colors.white60,
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }
}

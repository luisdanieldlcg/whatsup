import 'package:flutter/material.dart';
import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/theme.dart';

class ReceiverMessageCard extends StatelessWidget {
  final MessageModel message;
  const ReceiverMessageCard({
    super.key,
    required this.message,
  });

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: ListTile(
            title: Text(message.message),
            subtitle: Text(message.senderId),
          ),
        ),
      ),
    );
  }
}

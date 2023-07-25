import 'package:flutter/material.dart';

import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/theme.dart';

class ChatReplyBubble extends StatelessWidget {
  final bool isDarkEnabled;
  final MessageModel model;
  const ChatReplyBubble({
    Key? key,
    required this.isDarkEnabled,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 12, left: 12, right: 0),
              decoration: BoxDecoration(
                color: isDarkEnabled ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.repliedTo,
                    style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    model.repliedMessage,
                    style: TextStyle(
                        color: isDarkEnabled ? Colors.grey.shade400 : Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 5, bottom: 2),
            child: Text(model.message),
          ),
        ],
      ),
    );
  }
}

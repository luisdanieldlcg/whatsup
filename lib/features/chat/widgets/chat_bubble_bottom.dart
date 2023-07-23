// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:whatsup/common/models/message.dart';

class ChatBubbleBottom extends StatelessWidget {
  final MessageModel model;
  final bool isDark;
  const ChatBubbleBottom({
    Key? key,
    required this.model,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat.Hm().format(model.timeSent),
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
    );
  }
}

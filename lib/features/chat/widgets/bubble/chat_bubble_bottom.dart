// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:whatsup/common/models/message.dart';

class ChatBubbleBottom extends StatelessWidget {
  final MessageModel model;
  final bool isDark;
  final bool isAudio;
  final String audioLabel;
  const ChatBubbleBottom({
    Key? key,
    required this.model,
    required this.isDark,
    this.audioLabel = '',
    this.isAudio = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;
    const double fontSize = 13;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isAudio) ...{
          const Spacer(),
        },
        Text(
          audioLabel,
          style: TextStyle(
            fontSize: fontSize,
            color: fontColor,
          ),
        ),
        if (isAudio) ...{
          const Spacer(flex: 3),
        },
        Text(
          DateFormat.Hm().format(model.timeSent),
          style: TextStyle(
            fontSize: fontSize,
            color: fontColor,
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

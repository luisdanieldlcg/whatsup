import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/common/enum/message.dart';

class MessageDisplay extends StatelessWidget {
  final ChatMessageType type;
  final String message;
  const MessageDisplay({
    super.key,
    required this.type,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (type == ChatMessageType.text) {
      return Text(message, style: const TextStyle(fontSize: 16));
    }
    return CachedNetworkImage(imageUrl: message);
  }
}

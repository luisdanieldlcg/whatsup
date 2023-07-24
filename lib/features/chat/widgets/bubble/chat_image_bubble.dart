import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/theme.dart';

class ChatImageBubble extends StatelessWidget {
  final MessageModel model;
  final bool isDark;
  final bool isMessageSender;
  const ChatImageBubble({
    Key? key,
    required this.model,
    required this.isDark,
    required this.isMessageSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BubbleNormalImage(
      id: model.uid,
      isSender: isMessageSender,
      seen: model.isRead,
      delivered: true,
      color: isDark ? kPrimaryColor : kPrimaryColor.withOpacity(0.4).withAlpha(120).withGreen(165),
      image: CachedNetworkImage(
        imageUrl: model.message,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

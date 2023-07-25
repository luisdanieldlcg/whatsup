// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/features/chat/widgets/bubble/image_bubble.dart';

class ChatImageBubble extends ConsumerWidget {
  final MessageModel model;
  final bool isDark;
  final bool isMessageSender;
  final String receiverName;
  const ChatImageBubble({
    Key? key,
    required this.model,
    required this.isDark,
    required this.isMessageSender,
    required this.receiverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwipeTo(
      offsetDx: 0.16,
      onRightSwipe: () => makeReply(ref),
      child: ImageBubble(
        isDark: isDark,
        isReply: model.repliedMessage.isNotEmpty,
        message: model,
        id: model.uid,
        isSender: isMessageSender,
        tail: false,
        color:
            isDark ? kPrimaryColor : kPrimaryColor.withOpacity(0.4).withAlpha(120).withGreen(165),
        image: CachedNetworkImage(
          imageUrl: model.message,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: CircularProgressIndicator(
              value: progress.progress,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  void makeReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => Some(
          MessageReply(
            repliedTo: receiverName,
            message: model.message,
            isSenderMessage: isMessageSender,
            type: model.repliedMessageType,
          ),
        ));
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/features/chat/widgets/audio_player.dart';
import 'package:whatsup/features/chat/widgets/video_player.dart';

class MessageDisplay extends ConsumerWidget {
  final ChatMessageType type;
  final String message;
  const MessageDisplay({
    super.key,
    required this.type,
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case ChatMessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: CachedNetworkImage(
              imageUrl: message,
            ),
          ),
        );
      case ChatMessageType.video:
        return ChatVideoPlayer(url: message);
      case ChatMessageType.audio:
        return AudioMessagePlayer(message: message);
      default:
        return Text(
          message,
          style: const TextStyle(fontSize: 16),
        );
    }
  }
}

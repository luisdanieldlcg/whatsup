import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/theme.dart';
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
        return CachedNetworkImage(imageUrl: message);
      case ChatMessageType.video:
        return VideoPlayer(videoUrl: message);
      case ChatMessageType.audio:
        return AudioMessagePlayer(message: message);
      default:
        return Consumer(
          builder: (context, ref, _) {
            final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
            return Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            );
          },
        );
    }
  }
}

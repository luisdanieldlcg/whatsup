import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioMessagePlayer extends StatelessWidget {
  final String message;
  const AudioMessagePlayer({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final player = AudioPlayer();
    return StatefulBuilder(builder: (context, setState) {
      return IconButton(
        onPressed: () async {
          if (isPlaying) {
            await player.pause();
            setState(() => isPlaying = false);
          } else {
            await player.play(UrlSource(message));
            setState(() => isPlaying = true);
          }
        },
        icon: Icon(
          isPlaying ? Icons.pause_circle : Icons.play_circle,
        ),
      );
    });
  }
}

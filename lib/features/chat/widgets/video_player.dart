import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  const VideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CachedVideoPlayerController controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        controller.setVolume(1);
      });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(controller),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
                setState(() => isPlaying = !isPlaying);
              },
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsup/common/widgets/progress.dart';

enum VideoDataSource {
  network,
  asset,
  file,
}

class ChatVideoPlayer extends ConsumerStatefulWidget {
  final String url;
  final VideoDataSource src;
  const ChatVideoPlayer({
    super.key,
    required this.url,
    this.src = VideoDataSource.network,
  });

  @override
  ConsumerState<ChatVideoPlayer> createState() => _ChatVideoPlayerState();
}

class _ChatVideoPlayerState extends ConsumerState<ChatVideoPlayer> {
  late VideoPlayerController _videoController;
  bool isPlaying = false;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    switch (widget.src) {
      case VideoDataSource.network:
        _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
        break;
      case VideoDataSource.asset:
        _videoController = VideoPlayerController.asset(widget.url);
        break;
      case VideoDataSource.file:
        _videoController = VideoPlayerController.file(File(widget.url));
        break;
    }
    _videoController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          aspectRatio: 16 / 9,
          materialProgressColors: ChewieProgressColors(handleColor: Colors.red),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: _videoController.value.isInitialized
          ? Chewie(controller: _chewieController)
          : const WorkProgressIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
    _chewieController.dispose();
  }
}

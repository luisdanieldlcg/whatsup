// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:video_player/video_player.dart';

import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_bubble.dart';

enum VideoDataSource {
  network,
  asset,
  file,
}

class ChatVideoBubble extends ConsumerStatefulWidget {
  final MessageModel model;
  final bool isSenderMessage;
  final bool isMostRecentMessage;
  final String receiverName;
  final bool isRepeatedSender;
  final VideoDataSource src;
  final bool isGroup;

  const ChatVideoBubble({
    required this.model,
    required this.isSenderMessage,
    required this.isMostRecentMessage,
    required this.receiverName,
    required this.isRepeatedSender,
    this.src = VideoDataSource.network,
    required this.isGroup,
  });

  @override
  ConsumerState<ChatVideoBubble> createState() => _ChatVideoPlayerState();
}

class _ChatVideoPlayerState extends ConsumerState<ChatVideoBubble> {
  late VideoPlayerController _videoController;
  bool isPlaying = false;
  Option<ChewieController> _chewieController = const None();

  @override
  void initState() {
    super.initState();
    final String url = widget.model.message;

    switch (widget.src) {
      case VideoDataSource.network:
        _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
        break;
      case VideoDataSource.asset:
        _videoController = VideoPlayerController.asset(url);
        break;
      case VideoDataSource.file:
        _videoController = VideoPlayerController.file(File(url));
        break;
    }
    _videoController.initialize().then((_) {
      setState(() {
        _chewieController = Some(ChewieController(
          videoPlayerController: _videoController,
          aspectRatio: 16 / 9,
          materialProgressColors: ChewieProgressColors(handleColor: Colors.red),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      isGroup: widget.isGroup,
      receiverName: widget.receiverName,
      repeatedSender: widget.isRepeatedSender,
      model: widget.model,
      isSenderMessage: widget.isSenderMessage,
      isMostRecent: widget.isMostRecentMessage,
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: _chewieController.match(
          () => const WorkProgressIndicator(),
          (chewieController) => Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Chewie(controller: chewieController),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
    if (_chewieController.isSome()) {
      _chewieController.unwrap().dispose();
    }
  }
}

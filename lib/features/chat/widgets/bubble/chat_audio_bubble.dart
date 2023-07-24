// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/logger.dart';

class ChatAudioBubble extends ConsumerStatefulWidget {
  final String message;
  final bool isDark;
  final bool isMyMessage;
  const ChatAudioBubble({
    Key? key,
    required this.message,
    required this.isDark,
    required this.isMyMessage,
  }) : super(key: key);

  @override
  ConsumerState<ChatAudioBubble> createState() => _ChatAudioBubbleState();
}

class _ChatAudioBubbleState extends ConsumerState<ChatAudioBubble> {
  final player = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoading = false;
  Duration currentPos = Duration.zero;
  Duration maxDuration = Duration.zero;
  final logger = AppLogger.getLogger("AudioPlayer");

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        isLoading = true;
      });
      await player.setSourceUrl(widget.message);
      await player.setVolume(1.0);
      player.onDurationChanged.listen((event) {
        maxDuration = event;
      });
      player.onPositionChanged.listen((event) {
        currentPos = event;
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkBubbleColor =
        widget.isMyMessage ? kSenderMessageColorDark : kReceiverMessageColorDark;
    final lightBubbleColor = widget.isMyMessage ? kSenderMessageColorLight : Colors.white;

    return Theme(
      data: ThemeData(
        primaryColor: Colors.white,
        primaryColorDark: Colors.white,
      ),
      child: BubbleNormalAudio(
        textStyle: const TextStyle(color: Colors.grey),
        color: widget.isDark ? darkBubbleColor : lightBubbleColor,
        onSeekChanged: (e) {},
        duration: maxDuration.inSeconds.toDouble(),
        position: currentPos.inSeconds.toDouble(),
        isLoading: isLoading,
        isPlaying: isPlaying,
        isPause: isPaused,
        tail: false,
        onPlayPauseButtonClick: () async {
          if (isPlaying) {
            await player.pause();
          } else {
            // the source was set in initState
            await player.play(UrlSource(widget.message));
          }
          setState(() {
            isPlaying = !isPlaying;
            isPaused = !isPlaying;
          });
        },
      ),
      // ),

      // child: BubbleNormalAudio(

      // textStyle: const TextStyle(color: Colors.grey),

      // color: widget.isDark ? darkBubbleColor : lightBubbleColor,

      // onSeekChanged: (e) {},

      // duration: duration,

      // isLoading: isLoading,

      // isPlaying: isPlaying,

      // isPause: isPaused,

      // tail: false,

      // onPlayPauseButtonClick: () async {

      // if (isPlaying) {

      // await player.pause();

      // } else {

      // await player.play(UrlSource(widget.message));

      // }
//

      // setState(() {

      // isPlaying = !isPlaying;

      // isPaused = !isPlaying;

      // });

      // },

      // ),

      // );
      // }
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/logger.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_bubble.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_bubble_bottom.dart';

class ChatAudioBubble extends ConsumerStatefulWidget {
  final MessageModel message;
  final bool isGroup;
  final bool isDark;
  final bool isMyMessage;
  final bool repeatedSender;
  final bool isMostRecent;
  final String receiverName;
  final VoidCallback onAudioStarted;
  const ChatAudioBubble({
    Key? key,
    required this.message,
    required this.isGroup,
    required this.isDark,
    required this.isMyMessage,
    required this.repeatedSender,
    required this.isMostRecent,
    required this.receiverName,
    required this.onAudioStarted,
  }) : super(key: key);

  @override
  ConsumerState<ChatAudioBubble> createState() => _ChatAudioBubbleState();
}

enum AudioPlayerState {
  stopped,
  playing,
  paused,
  loading,
  idle,
  uninitialized,
}

class _ChatAudioBubbleState extends ConsumerState<ChatAudioBubble> {
  final player = AudioPlayer();
  Duration currentPos = Duration.zero;
  Duration maxDuration = Duration.zero;
  AudioPlayerState state = AudioPlayerState.uninitialized;
  final logger = AppLogger.getLogger("AudioPlayer");

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        state = AudioPlayerState.loading;
      });
      await player.setSourceUrl(widget.message.message);
      await player.setVolume(1.0);
      maxDuration = (await player.getDuration()) ?? Duration.zero;
      attachEventListeners();
      setState(() {
        state = AudioPlayerState.idle;
      });
    });
  }

  void attachEventListeners() {
    player.onDurationChanged.listen((event) {
      maxDuration = event;
      setState(() {});
    });
    player.onPositionChanged.listen((event) {
      currentPos = event;
      if (currentPos.inSeconds >= maxDuration.inSeconds) {
        currentPos = Duration.zero;
        player.seek(Duration.zero);
        player.pause();
        state = AudioPlayerState.paused;
      }
      setState(() {});
    });
  }

  String get audioLabel {
    if (state == AudioPlayerState.playing) {
      // if we are playing the audio we return our current position
      // formatted as mm:ss
      // return '${currentPos.inMinutes}:${currentPos.inSeconds.remainder(60)}';
      // make sure it shows 2 digits for seconds e.g 0:00
      return '${currentPos.inMinutes}:${currentPos.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    }
    // otherwise we return the duration of the audio
    return '${maxDuration.inMinutes}:${maxDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void handlePress() async {
    switch (state) {
      case AudioPlayerState.idle:
        player.play(UrlSource(widget.message.message));
        state = AudioPlayerState.playing;
        widget.onAudioStarted();
        break;
      case AudioPlayerState.playing:
        player.pause();
        state = AudioPlayerState.paused;
        break;
      case AudioPlayerState.paused:
        player.resume();
        state = AudioPlayerState.playing;
        break;
      default:
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final thumbColor = widget.isMyMessage
        ? Colors.lightBlue.shade300
        : widget.message.isRead
            ? Colors.lightBlue.shade300
            : kPrimaryColor;
    return ChatBubble(
      isGroup: widget.isGroup,
      isSenderMessage: widget.isMyMessage,
      model: widget.message,
      repeatedSender: widget.repeatedSender,
      isMostRecent: widget.isMostRecent,
      receiverName: widget.receiverName,
      audioLabel: audioLabel,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  splashRadius: 1,
                  onPressed: handlePress,
                  icon: Icon(
                    state == AudioPlayerState.playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 4,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                    ),
                    child: Slider.adaptive(
                      value: currentPos.inSeconds.toDouble(),
                      min: 0,
                      max: maxDuration.inSeconds.toDouble(),
                      thumbColor: thumbColor,
                      secondaryActiveColor: Colors.grey,
                      activeColor: widget.isDark
                          ? const Color.fromARGB(255, 239, 239, 239)
                          : Colors.grey.shade600,
                      inactiveColor: Colors.grey.shade600,
                      onChanged: (value) {
                        setState(() {
                          currentPos = Duration(seconds: value.toInt());
                        });
                        player.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 60,
            bottom: -2,
            child: Text(
              audioLabel,
              style: TextStyle(
                fontSize: 13,
                color: widget.isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
          )
        ],
      ),
    );
  }
}

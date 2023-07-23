import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/features/chat/controller/chat_controller.dart';
import 'package:whatsup/features/chat/widgets/reply_container.dart';

class ChatInputArea extends ConsumerStatefulWidget {
  final String receiverId;
  final String receiverName;
  final bool isGroup;
  const ChatInputArea({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.isGroup,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends ConsumerState<ChatInputArea> {
  final messageController = TextEditingController();
  Option<FlutterSoundRecorder> soundRecorder = const None();
  bool isSoundRecorderReady = false;
  bool isRecording = false;
  bool isTyping = false;
  bool shouldShowEmojis = false;
  final keyboardFocus = FocusNode();
  static const kIconSplashRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    final reply = ref.watch(messageReplyProvider);
    final isShowingReply = reply.isSome();
    final theme = ref.watch(themeNotifierProvider);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 2.0, bottom: 6.0),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 1.5,
                  child: Column(
                    children: [
                      if (isShowingReply) ...{
                        ReplyContainer(replyingTo: widget.receiverName),
                      },
                      TextField(
                        focusNode: keyboardFocus,
                        controller: messageController,
                        onChanged: (text) {
                          setState(() {
                            // check text has anything appart from white space
                            // we dont want to send empty messages
                            isTyping = text.trim().isNotEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          fillColor:
                              theme == Brightness.dark ? kDarkTextFieldBgColor : Colors.white,
                          filled: true,
                          hintText: "Type a message",
                          isDense: false,
                          prefixIcon: IconButton(
                            splashRadius: kIconSplashRadius,
                            onPressed: toggleEmojiKeyboard,
                            icon: const Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          suffixIcon: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  splashRadius: kIconSplashRadius,
                                  onPressed: selectImage,
                                  icon: const Icon(Icons.camera_alt, color: Colors.grey),
                                ),
                                IconButton(
                                  splashRadius: kIconSplashRadius,
                                  onPressed: selectVideo,
                                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: isShowingReply ? Radius.zero : const Radius.circular(20),
                              topRight: isShowingReply ? Radius.zero : const Radius.circular(20),
                              bottomLeft: const Radius.circular(20),
                              bottomRight: const Radius.circular(20),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: isShowingReply ? Radius.zero : const Radius.circular(20),
                              topRight: isShowingReply ? Radius.zero : const Radius.circular(20),
                              bottomLeft: const Radius.circular(20),
                              bottomRight: const Radius.circular(20),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(10.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                width: 48,
                height: 48,
                child: FloatingActionButton(
                  onPressed: sendText,
                  child: Icon(micIcon),
                ),
              ),
            ),
          ],
        ),
        if (shouldShowEmojis) ...{
          SizedBox(
            height: 310,
            child: EmojiPicker(
              onEmojiSelected: ((category, emoji) {
                setState(() {
                  isTyping = true;
                  messageController.text = messageController.text + emoji.emoji;
                });
              }),
            ),
          ),
        }
      ],
    );
  }

  IconData get micIcon => isTyping
      ? Icons.send
      : isRecording
          ? Icons.stop
          : Icons.mic;

  @override
  void initState() {
    super.initState();
    soundRecorder = Some(FlutterSoundRecorder());
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return;
    }
    await soundRecorder.unwrap().openRecorder();
    isSoundRecorderReady = true;
  }

  void sendFile(File file, ChatMessageType type) async {
    ref.read(chatControllerProvider).sendFile(
          context: context,
          receiverId: widget.receiverId,
          file: file,
          type: type,
          isGroup: widget.isGroup,
        );
  }

  void selectImage() async {
    final maybeImage = await pickGalleryImage(context);
    if (maybeImage.isSome()) {
      sendFile(maybeImage.unwrap(), ChatMessageType.image);
    }
  }

  void selectVideo() async {
    final maybeImage = await pickVideoFromGallery(context);
    if (maybeImage.isSome()) {
      sendFile(maybeImage.unwrap(), ChatMessageType.video);
    }
  }

  void sendText() async {
    if (!isTyping) {
      if (!isSoundRecorderReady) return;
      // check if it's recording
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/flutter_sound.aac';
      if (isRecording) {
        await soundRecorder.unwrap().stopRecorder();
        sendFile(File(path), ChatMessageType.audio);
      } else {
        await soundRecorder.unwrap().startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    } else {
      // user is typing
      ref.read(chatControllerProvider).sendText(
          context: context,
          text: messageController.text,
          receiverId: widget.receiverId,
          isGroup: widget.isGroup);
    }

    messageController.clear();
    setState(() {
      isTyping = false;
    });
  }

  void showKeyboard() {
    keyboardFocus.requestFocus();
  }

  void hideKeyboard() {
    keyboardFocus.unfocus();
  }

  void showEmojis() {
    setState(() {
      shouldShowEmojis = true;
    });
  }

  void hideEmojis() {
    setState(() {
      shouldShowEmojis = false;
    });
  }

  void toggleEmojiKeyboard() {
    setState(() {
      shouldShowEmojis = !shouldShowEmojis;
    });

    if (shouldShowEmojis) {
      hideKeyboard();
      showEmojis();
    } else {
      showKeyboard();
      hideEmojis();
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    soundRecorder.unwrap().closeRecorder();
    isSoundRecorderReady = false;
  }
}

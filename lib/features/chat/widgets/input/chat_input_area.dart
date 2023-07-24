import 'dart:async';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/file_picker.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/features/chat/controller/chat_controller.dart';
import 'package:whatsup/features/chat/widgets/input/chat_input_card.dart';
import 'package:whatsup/features/chat/widgets/input/chat_keyboard.dart';

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
  final _inputController = TextEditingController();
  Option<FlutterSoundRecorder> soundRecorder = const None();
  bool isSoundRecorderReady = false;
  bool isRecording = false;
  bool isTyping = false;
  bool shouldRenderEmojiKeyboard = false;
  bool showAttachFileSheet = false;
  bool isRecordLongEnough = false;

  @override
  Widget build(BuildContext context) {
    final reply = ref.watch(messageReplyProvider);
    final isShowingReply = reply.isSome();
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    return TapRegion(
      onTapOutside: (_) {
        if (showAttachFileSheet) {
          closeFileSheet();
        }
      },
      child: Column(
        children: [
          ChatAttachmentCard(
            height: showAttachFileSheet ? MediaQuery.of(context).size.height * .4 : 0,
            isDark: isDark,
            openImageGallery: attachGalleryImage,
            openCamera: attachCamera,
            openVideoGallery: attachGalleryVideo,
          ),
          const SizedBox(height: 3),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: ChatKeyboard(
                    controller: _inputController,
                    showReplyBox: isShowingReply,
                    receiverName: widget.receiverName,
                    attachFile: toggleAttachFileSheet,
                    attachCamera: attachCamera,
                    onEmojiTapped: toggleEmojiKeyboard,
                    onChanged: updateTypingStatus,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3, bottom: 5),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: FloatingActionButton(
                      elevation: 0,
                      onPressed: sendText,
                      child: Icon(micIcon),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            height: shouldRenderEmojiKeyboard ? 300 : 0,
            duration: const Duration(milliseconds: 200),
            child: EmojiPicker(
              onEmojiSelected: ((category, emoji) {
                setState(
                  () {
                    isTyping = true;
                    _inputController.text = _inputController.text + emoji.emoji;
                  },
                );
              }),
            ),
          ),
        ],
      ),
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
    openAudio();
  }

  void toggleAttachFileSheet() {
    setState(() {
      showAttachFileSheet = !showAttachFileSheet;
    });
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return;
    }
    final audio = await FlutterSoundRecorder().openRecorder();
    if (audio != null) {
      audio.setLogLevel(Level.error);
    }
    soundRecorder = Option.fromNullable(audio);
    isSoundRecorderReady = true;
  }

  void sendFile(File file, MessageType type) async {
    closeFileSheet();
    ref.read(chatControllerProvider).sendFile(
          context: context,
          receiverId: widget.receiverId,
          file: file,
          type: type,
          isGroup: widget.isGroup,
        );
  }

  void toggleRecording() async {
    if (!isSoundRecorderReady) return;
    // check if it's recording
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/flutter_sound.aac';
    if (isRecording) {
      await soundRecorder.unwrap().stopRecorder();
      if (isRecordLongEnough) {
        sendFile(File(path), MessageType.audio);
      }
    } else {
      await soundRecorder.unwrap().startRecorder(toFile: path);
      Future.delayed(const Duration(milliseconds: 1001), () {
        if (isRecording) {
          isRecordLongEnough = true;
        } else {
          showSnackbar(context, 'Audio must be at least 1 second long');
        }
      });
    }
    setState(() {
      isRecording = !isRecording;
    });
  }

  void sendText() async {
    if (!isTyping) {
      toggleRecording();
    } else {
      // user is typing
      ref.read(chatControllerProvider).sendText(
          context: context,
          text: _inputController.text,
          receiverId: widget.receiverId,
          isGroup: widget.isGroup);
    }

    _inputController.clear();
    setState(() {
      isTyping = false;
    });
  }

  void toggleEmojiKeyboard(bool shouldRender) {
    // close file sheet
    closeFileSheet();

    setState(() {
      shouldRenderEmojiKeyboard = shouldRender;
    });
  }

  void updateTypingStatus(String text) {
    setState(() {
      isTyping = text.trim().isNotEmpty;
    });
  }

  void attachGalleryImage() async {
    final maybeImage = await FilePicker.pickFile(FilePickerSource.galleryImage);
    if (maybeImage.isSome()) {
      sendFile(maybeImage.unwrap(), MessageType.image);
    }
  }

  void attachCamera() async {
    final image = await FilePicker.pickFile(FilePickerSource.camera);
    if (image.isSome()) {
      sendFile(image.unwrap(), MessageType.image);
    }
  }

  void attachGalleryVideo() async {
    final maybeImage = await FilePicker.pickFile(FilePickerSource.galleryVideo);
    if (maybeImage.isSome()) {
      sendFile(maybeImage.unwrap(), MessageType.video);
    }
  }

  void closeFileSheet() {
    setState(() {
      showAttachFileSheet = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
    soundRecorder.unwrap().closeRecorder();
    isSoundRecorderReady = false;
  }
}

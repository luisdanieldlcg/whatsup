import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/models/status.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/features/status/controller/status_controller.dart';

class StatusWriterPage extends ConsumerStatefulWidget {
  const StatusWriterPage({super.key});

  @override
  ConsumerState<StatusWriterPage> createState() => _StatusWriterPageState();
}

class _StatusWriterPageState extends ConsumerState<StatusWriterPage> {
  Color bg = Colors.black;
  bool showEmojiKeyboard = false;
  FocusNode keyboardFocus = FocusNode();
  final textController = TextEditingController();
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (textController.text.isEmpty) return true;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Discard this status?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    'Discard',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: const CloseButton(
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
            ),
            actions: [
              IconButton(
                splashRadius: kDefaultSplashRadius,
                onPressed: toggleEmojiKeyboard,
                icon: Icon(
                    showEmojiKeyboard ? Icons.keyboard_outlined : Icons.emoji_emotions_outlined),
              ),
              IconButton(
                splashRadius: kDefaultSplashRadius,
                onPressed: () {
                  setState(() {
                    bg = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                  });
                },
                icon: const Icon(Icons.palette_outlined),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  maxLines: null,
                  controller: textController,
                  focusNode: keyboardFocus,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Type a status',
                    hintStyle: TextStyle(fontSize: 24, color: Colors.white),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const Spacer(),
              if (showEmojiKeyboard) ...{
                SizedBox(
                  height: 300,
                  child: EmojiPicker(
                    onEmojiSelected: ((category, emoji) {
                      setState(() {
                        textController.text = textController.text + emoji.emoji;
                      });
                    }),
                  ),
                )
              },
            ],
          ),
          // send button
          floatingActionButton: Column(
            children: [
              const Spacer(),
              if (showEmojiKeyboard) ...{
                const SizedBox(height: 125.0),
              },
              FloatingActionButton(
                elevation: 1.0,
                onPressed: addStatus,
                child: sending ? const CircularProgressIndicator() : const Icon(Icons.send),
              ),
              if (showEmojiKeyboard) ...{
                const Spacer(),
              }
            ],
          )),
    );
  }

  void addStatus() async {
    setState(() {
      sending = true;
    });
    ref.read(statusControllerProvider).uploadTextStatus(
          text: StatusText(text: textController.text.trim(), bgColor: bg),
          context: context,
        );
    Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        sending = false;
      });
      Navigator.pop(context);
    }
  }

  void toggleEmojiKeyboard() {
    setState(() {
      showEmojiKeyboard = !showEmojiKeyboard;
    });
    if (showEmojiKeyboard) {
      keyboardFocus.unfocus();
    } else {
      keyboardFocus.requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    bg = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/features/chat/controller/chat_controller.dart';

class ChatTextField extends ConsumerStatefulWidget {
  final String receiverId;
  const ChatTextField({
    super.key,
    required this.receiverId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  bool isTyping = false;
  final messageController = TextEditingController();

  void sendText() {
    if (!isTyping) return;
    ref.read(chatControllerRepository).sendText(
          context: context,
          text: messageController.text,
          receiverId: widget.receiverId,
        );
    messageController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 2.0, bottom: 6.0),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 1.5,
              child: TextField(
                controller: messageController,
                onChanged: (text) {
                  setState(() {
                    // check text has anything appart from white space
                    // we dont want to send empty messages
                    isTyping = text.trim().isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Type a message",
                  isDense: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                ),
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
              child: Icon(
                isTyping ? Icons.send : Icons.mic,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

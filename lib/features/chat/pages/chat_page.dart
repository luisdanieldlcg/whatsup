import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/widgets/avatar.dart';
import 'package:whatsup/features/chat/widgets/chat_messages.dart';
import 'package:whatsup/features/chat/widgets/chat_textfield.dart';

class ChatPage extends ConsumerStatefulWidget {
  /// The user that is being chatted with
  final UserModel otherUser;

  const ChatPage({
    super.key,
    required this.otherUser,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.otherUser.profileImage),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherUser.name),
                const SizedBox(height: 3),
                const Text(
                  "Offline",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400, color: kUnselectedLabelColor),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessages(receiverId: widget.otherUser.uid)),
          ChatTextField(receiverId: widget.otherUser.uid)
        ],
      ),
    );
  }
}

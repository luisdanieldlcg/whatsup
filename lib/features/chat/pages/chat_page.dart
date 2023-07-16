import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/widgets/avatar.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Avatar(),
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
        children: [],
      ),
      bottomSheet: Row(
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
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Type a message",
                    isDense: false,
                    border: OutlineInputBorder(
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
                onPressed: () {},
                child: const Icon(Icons.send),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

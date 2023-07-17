import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/features/chat/controller/chat_controller.dart';
import 'package:whatsup/router.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveChats = ref.watch(chatsStreamProvider);
    return liveChats.when(
      data: (chats) {
        if (chats.isEmpty) {
          return const Center(
            child: Text('No chats yet'),
          );
        }
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ListTile(
              onTap: () {
                final UserModel otherUser = UserModel(
                  uid: chat.receiverId,
                  name: chat.name,
                  profileImage: chat.profileImage,
                  isOnline: true,
                  phoneNumber: '',
                );
                Navigator.pushNamed(context, PageRouter.chat, arguments: otherUser);
              },
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(chat.profileImage),
              ),
              trailing: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  DateFormat.Hm().format(chat.lastMessageTime),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              title: Text(chat.name),
              subtitle: Text(chat.lastMessage),
            );
          },
        );
      },
      error: (err, trace) => UnhandledError(error: err.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

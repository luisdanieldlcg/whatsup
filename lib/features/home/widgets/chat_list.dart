import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/auth/controllers/auth.dart';
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
            final liveMessages = ref.watch(messagesStreamProvider(chat.receiverId));
            return liveMessages.when(
              data: (messages) {
                final unread = messages.where((msg) {
                  return msg.recvId == ref.read(authControllerProvider).currentUser.unwrap().uid &&
                      !msg.isRead;
                }).length;
                return ListTile(
                  onTap: () {
                    final otherUser = UserModel(
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
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (unread > 0) ...{},
                      const Spacer(),
                      Text(
                        DateFormat.Hm().format(chat.lastMessageTime),
                        style: TextStyle(
                            color: unread > 0 ? kPrimaryColor : Colors.grey, fontSize: 13),
                      ),
                      if (unread > 0) ...{
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            child: Text(
                              unread.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      },
                      const Spacer(),
                    ],
                  ),
                  title: Text(chat.name),
                  subtitle: Text(chat.lastMessage),
                );
              },
              error: (err, trace) => UnhandledError(error: err.toString()),
              loading: () => const WorkProgressIndicator(),
            );
          },
        );
      },
      error: (err, trace) => UnhandledError(error: err.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

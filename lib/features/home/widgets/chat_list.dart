import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/chat/controller/chat_controller.dart';
import 'package:whatsup/features/chat/widgets/chat_tile.dart';
import 'package:whatsup/router.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveChats = ref.watch(chatsStreamProvider);
    final liveGroups = ref.watch(groupsStreamProvider);
    final userId = getUserId(ref);
    return liveChats.when(
      data: (chats) {
        return liveGroups.when(
          data: (groups) {
            if (chats.isEmpty && groups.isEmpty) {
              return const EmtyChatList();
            }
            return ListView.builder(
              itemCount: chats.length + groups.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index < chats.length) {
                  final chat = chats[index];
                  final liveMessages = ref.watch(messagesStreamProvider(chat.receiverId));
                  return liveMessages.when(
                    data: (messages) {
                      // Get the messages where the current user is the receiver and the message is not read
                      final unread = messages.where((x) => x.recvId == userId && !x.isRead).length;
                      return ChatListTile(
                        name: chat.name,
                        lastMessage: chat.lastMessage,
                        lastMessageTime: chat.lastMessageTime,
                        avatarImage: chat.profileImage,
                        unreadMessages: unread,
                        onTap: () {
                          onChatTap(
                            receiver: chat.receiverId,
                            name: chat.name,
                            image: chat.profileImage,
                            context: context,
                            isGroup: false,
                          );
                        },
                      );
                    },
                    error: (err, trace) => UnhandledError(error: err.toString()),
                    loading: () => const SizedBox(),
                  );
                }
                final group = groups[index - chats.length];
                return ChatListTile(
                  name: group.name,
                  lastMessage: group.lastMessage,
                  lastMessageTime: group.lastMessageTime,
                  avatarImage: group.groupImage,
                  unreadMessages: 0,
                  onTap: () {
                    onChatTap(
                      receiver: group.groupId,
                      name: group.name,
                      image: group.groupImage,
                      context: context,
                      isGroup: true,
                    );
                  },
                );
              },
            );
          },
          error: (error, _) => UnhandledError(error: error.toString()),
          loading: () => const SizedBox(),
        );
      },
      error: (error, trace) => UnhandledError(error: error.toString()),
      loading: () => const WorkProgressIndicator(),
    );
  }

  void onChatTap({
    required String receiver,
    required String name,
    required String image,
    required BuildContext context,
    required bool isGroup,
  }) {
    Navigator.pushNamed(context, PageRouter.chat, arguments: {
      'isGroup': isGroup,
      'streamId': receiver,
      'name': name,
      'avatarImage': image,
    });
  }
}

class EmtyChatList extends StatelessWidget {
  const EmtyChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 84),
          SizedBox(height: 25),
          Text('No chats yet'),
          SizedBox(height: 180),
        ],
      ),
    );
  }
}

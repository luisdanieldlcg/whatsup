// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:whatsup/common/theme.dart';

class ChatListTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String avatarImage;
  final int unreadMessages;
  final VoidCallback onTap;
  const ChatListTile({
    Key? key,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatarImage,
    required this.unreadMessages,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(lastMessage),
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(avatarImage),
        backgroundColor: Colors.grey.withOpacity(0.2),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            DateFormat.Hm().format(lastMessageTime),
            style: TextStyle(color: unreadMessages > 0 ? kPrimaryColor : Colors.grey, fontSize: 13),
          ),
          if (unreadMessages > 0) ...{
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
                  unreadMessages.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          },
          const Spacer(),
        ],
      ),
    );
  }
}

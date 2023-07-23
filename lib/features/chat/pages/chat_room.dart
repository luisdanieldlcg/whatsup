// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/call/controller/call_controller.dart';
import 'package:whatsup/features/call/widgets/call_invitation_button.dart';
import 'package:whatsup/features/chat/widgets/message_list.dart';
import 'package:whatsup/features/chat/widgets/chat_room_app_bar.dart';
import 'package:whatsup/features/chat/widgets/chat_room_scaffold.dart';
import 'package:whatsup/features/chat/widgets/chat_input_area.dart';

class ChatRoomPage extends ConsumerWidget {
  final String streamId;
  final String avatarImage;
  final String name;
  final bool isGroup;

  const ChatRoomPage({
    super.key,
    required this.streamId,
    required this.avatarImage,
    required this.name,
    required this.isGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ChatRoomScaffold(
      appBar: ChatRoomAppBar(
        roomAvatar: avatarImage,
        roomName: name,
        isGroupRoom: isGroup,
        streamId: streamId,
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageList(
              receiverId: streamId,
              receiverName: name,
              isGroup: isGroup,
            ),
          ),
          ChatInputArea(
            receiverId: streamId,
            receiverName: name,
            isGroup: isGroup,
          )
        ],
      ),
    );
  }
}

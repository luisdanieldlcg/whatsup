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

class ChatRoomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool isGroupRoom;
  final String roomAvatar;
  final String roomName;
  final String streamId;
  const ChatRoomAppBar({
    Key? key,
    required this.isGroupRoom,
    required this.roomAvatar,
    required this.roomName,
    required this.streamId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveReceiver = ref.watch(userStream(streamId));
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
        splashRadius: kDefaultSplashRadius,
      ),
      title: isGroupRoom
          ? _GroupChatAppBar(roomAvatar: roomAvatar, roomName: roomName)
          : _OneToOneChatAppBar(roomAvatar: roomAvatar, roomName: roomName, streamId: streamId),
      actions: [
        if (!isGroupRoom) ...{
          liveReceiver.when(
            data: (participant) {
              return CallInvitationSendButton(
                isVideoCall: true,
                participants: [participant],
                onPressed: () {
                  makeCall(ref, context);
                },
              );
            },
            error: (err, trace) => UnhandledError(error: err.toString()),
            loading: () => const SizedBox(),
          ),
        },
        IconButton(
          splashRadius: kDefaultSplashRadius,
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          receiverId: streamId,
          receiverName: roomName,
          receiverProfileImage: roomAvatar,
          context: context,
          isGroupChat: isGroupRoom,
        );
  }
}

class _OneToOneChatAppBar extends ConsumerWidget {
  final String roomAvatar;
  final String roomName;
  final String streamId;
  const _OneToOneChatAppBar({
    required this.roomAvatar,
    required this.roomName,
    required this.streamId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveStream = ref.watch(userStream(streamId));
    return liveStream.when(
      data: (recvUserModel) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.2),
                backgroundImage: NetworkImage(roomAvatar),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(roomName),
                const SizedBox(height: 3),
                Text(
                  recvUserModel.isOnline ? "Online" : "Offline",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kUnselectedLabelColor,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        );
      },
      error: (err, trace) => UnhandledError(error: err.toString()),
      loading: () => const WorkProgressIndicator(),
    );
  }
}

class _GroupChatAppBar extends StatelessWidget {
  final String roomAvatar;
  final String roomName;
  const _GroupChatAppBar({
    Key? key,
    required this.roomAvatar,
    required this.roomName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.2),
            backgroundImage: NetworkImage(roomAvatar),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(roomName),
            const Padding(
              padding: EdgeInsets.only(left: 2.0, top: 5),
              child: Text(
                "Tap here for group info",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

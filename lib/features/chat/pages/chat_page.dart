// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/call/controller/call_controller.dart';
import 'package:whatsup/features/call/pages/incoming_call.dart';
import 'package:whatsup/features/call/widgets/call_invitation_button.dart';
import 'package:whatsup/features/chat/widgets/chat_messages.dart';
import 'package:whatsup/features/chat/widgets/chat_textfield.dart';

class ChatPage extends ConsumerWidget {
  final String streamId;
  final String avatarImage;
  final String name;
  final bool isGroup;

  const ChatPage({
    super.key,
    required this.streamId,
    required this.avatarImage,
    required this.name,
    required this.isGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveReceiver = ref.watch(userStream(streamId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          splashRadius: kDefaultSplashRadius,
        ),
        title: isGroup
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avatarImage),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name),
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
              )
            : liveReceiver.when(
                data: (recvUserModel) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(avatarImage),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name),
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
              ),
        actions: [
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
          IconButton(
            splashRadius: kDefaultSplashRadius,
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              receiverId: streamId,
              receiverName: name,
              isGroup: isGroup,
            ),
          ),
          ChatTextField(
            receiverId: streamId,
            receiverName: name,
            isGroup: isGroup,
          )
        ],
      ),
    );
  }

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          receiverId: streamId,
          receiverName: name,
          receiverProfileImage: avatarImage,
          context: context,
          isGroupChat: isGroup,
        );
  }
}

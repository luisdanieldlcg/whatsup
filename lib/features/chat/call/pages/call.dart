import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/models/call.dart';
import 'package:whatsup/common/repositories/auth.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/config.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends ConsumerStatefulWidget {
  final String channelId;
  final CallModel model;
  final bool isGroup;
  const CallPage({
    super.key,
    required this.channelId,
    required this.model,
    required this.isGroup,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallPageState();
}

class _CallPageState extends ConsumerState<CallPage> {
  @override
  Widget build(BuildContext context) {
    final userId = ref.read(authRepositoryProvider).currentUser.unwrap().uid;
    return ZegoUIKitPrebuiltCall(
      appID: AppConfig.zegoCloudAppId,
      appSign: AppConfig.zeroCloudAppSign,
      userID: userId,
      userName: 'Daniel',
      callID: widget.channelId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..avatarBuilder = (context, size, user, extraInfo) {
          if (user == null) return const SizedBox.shrink();
          return CircleAvatar(
            radius: size.width / 2,
            backgroundImage: NetworkImage(widget.model.callerImage),
          );
        }
        ..onOnlySelfInRoom = (context) {
          // Navigator.pop(context);
        },
    );
  }
}

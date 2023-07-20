import 'package:flutter/material.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallInvitationSendButton extends StatelessWidget {
  final bool isVideoCall;
  final List<UserModel> participants;
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? fgColor;
  const CallInvitationSendButton({
    super.key,
    required this.isVideoCall,
    required this.participants,
    required this.onPressed,
    this.bgColor,
    this.fgColor,
  });

  @override
  Widget build(BuildContext context) {
    final invitees = participants.map((entry) => ZegoUIKitUser(id: entry.uid, name: entry.name));
    return FittedBox(
      child: ZegoSendCallInvitationButton(
        onPressed: (_, __, ___) => onPressed(),
        resourceID: 'whatsup_call',
        invitees: invitees.toList(),
        isVideoCall: isVideoCall,
        icon: ButtonIcon(
          icon: Icon(
            isVideoCall ? Icons.videocam : Icons.phone,
            color: fgColor ?? Colors.white,
            size: 52,
          ),
          backgroundColor: bgColor ?? Colors.transparent,
        ),
      ),
    );
  }
}

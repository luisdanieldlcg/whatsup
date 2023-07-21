import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/config.dart';
import 'package:whatsup/features/call/repository/call_repository.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Refer to: https://docs.zegocloud.com/article/14826 for more information
class CallInvitationService {
  // call this method after user login
  static void init({
    required String userID,
    required String userName,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: AppConfig.zegoCloudAppId,
      appSign: AppConfig.zeroCloudAppSign,
      userID: userID,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      events: ZegoUIKitPrebuiltCallInvitationEvents(
        onIncomingCallTimeout: (callId, caller) {
          ref.read(callRepositoryProvider).markAsDeclined(
                userID,
              );
        },
        onIncomingCallDeclineButtonPressed: () {
          ref.read(callRepositoryProvider).markAsDeclined(
                userID,
              );
        },
        onOutgoingCallDeclined: (callId, user) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  static void useSysCallUI() {
    ZegoUIKit().initLog().then((value) {
      ///  Call the `useSystemCallingUI` method
      ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
        [ZegoUIKitSignalingPlugin()],
      );
    });
  }

  static void uinit() {
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  static void attachNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  }
}

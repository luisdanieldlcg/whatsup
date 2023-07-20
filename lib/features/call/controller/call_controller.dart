import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsup/common/models/call.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/features/call/repository/call_repository.dart';
import 'package:whatsup/router.dart';

final callControllerProvider = Provider<CallController>((ref) {
  return CallController(
    call: ref.read(callRepositoryProvider),
    ref: ref,
  );
});

final userCallStreamProvider = StreamProvider<List<CallModel>>((ref) {
  return ref.watch(callRepositoryProvider).userCalls;
});

class CallController {
  final CallRepository _call;
  final Ref _ref;

  const CallController({
    required CallRepository call,
    required Ref ref,
  })  : _call = call,
        _ref = ref;

  void endCall(String callerId, String receiverId) {
    _call.endCall(callerId: callerId, receiverId: receiverId);
  }

  void markAsDeclined(String receiverId) {
    _call.markAsDeclined(receiverId);
  }

  void makeCall({
    required String receiverId,
    required String receiverName,
    required String receiverProfileImage,
    required BuildContext context,
    required bool isGroupChat,
  }) {
    _ref.read(userFetchProvider).whenData((value) {
      if (value.isSome()) {
        final user = value.unwrap();
        final sender = CallModel(
          callerId: user.uid,
          callerName: user.name,
          callerImage: user.profileImage,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverImage: receiverProfileImage,
          callId: const Uuid().v4(),
          date: DateTime.now(),
          missedOrDeclined: false,
        );

        // final receiver = CallModel(
        //   callerId: user.uid,
        //   callerName: user.name,
        //   callerImage: user.profileImage,
        //   receiverId: receiverId,
        //   receiverName: receiverName,
        //   receiverImage: receiverProfileImage,
        //   callId: sender.callId,
        //   date: DateTime.now(),
        //   missedOrDeclined: false,
        // );

        _call.makeCall(sender).then((value) {
          Navigator.pushNamed(context, PageRouter.call, arguments: {
            'isGroup': isGroupChat,
            'channelId': sender.callId,
            'model': sender,
          });
        });
      }
    });
  }
}

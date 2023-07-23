import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/models/call.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/logger.dart';

final callRepositoryProvider = Provider<CallRepository>((ref) {
  return CallRepository(
    db: ref.read(userRepositoryProvider),
  );
});

class CallRepository {
  final UserRepository _db;
  static final _logger = AppLogger.getLogger((CallRepository).toString());

  const CallRepository({
    required UserRepository db,
  }) : _db = db;

  Future<void> markAsDeclined(String receiverId) {
    return _db.activeUser.match(
      () => Future.value(),
      (user) async {
        try {
          // await _db.calls.where('receiverId', isEqualTo: receiverId).update({
          //   'missedOrDeclined': true,
          // });
          // update the missedOrDeclined field of the call with the given receiverId to true
          // however, the document id is unknown

          // so we need to query the call with the given receiverId
          // and update the first document returned
          final querySnapshot = await _db.calls.where('receiverId', isEqualTo: receiverId).get();
          final doc = querySnapshot.docs.first;
          await doc.reference.update({
            'missedOrDeclined': true,
          });
        } catch (e) {
          _logger.e(e.toString());
        }
      },
    );
  }

  Future<void> endCall({
    required String callerId,
    required String receiverId,
  }) async {
    try {
      await _db.calls.doc(callerId).delete();
      await _db.calls.doc(receiverId).delete();
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<void> makeCall(CallModel call) async {
    try {
      await _db.calls.doc().set(call);
      // await _db.calls.doc().set(receiver);
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Stream<List<CallModel>> get userCalls {
    return _db.activeUser.match(
      () => const Stream.empty(),
      (user) {
        return _db.calls.snapshots().map((snapshot) {
          return snapshot.docs
              .map((doc) => doc.data())
              // as of now firebase does not supports OR filter query :/
              .where((call) => call.callerId == user.uid || call.receiverId == user.uid)
              .toList();
        });
      },
    );
  }
}

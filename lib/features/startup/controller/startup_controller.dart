import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/repositories/auth.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/ext.dart';

final startUpControllerProvider = Provider<StartUpController>((ref) {
  return StartUpController(
    userRepository: UserRepository(
      authRepository: ref.watch(authRepositoryProvider),
      db: ref.watch(dbProvider),
      ref: ref,
    ),
  );
});

class StartUpController {
  final UserRepository _userRepository;
  const StartUpController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  Future<void> updateOnlineState(bool isOnline) async {
    if (_userRepository.activeUser.isNone()) return;
    final user = _userRepository.activeUser.unwrap();
    await _userRepository.users.doc(user.uid).update({
      kIsOnlineField: isOnline,
    });
  }
}

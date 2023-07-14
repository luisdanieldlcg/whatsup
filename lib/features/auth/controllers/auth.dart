import 'package:flutter_firebase_template/common/models/user.dart';
import 'package:flutter_firebase_template/common/repositories/auth.dart';
import 'package:flutter_firebase_template/common/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    repository: ref.watch(authRepository),
  ),
);

class AuthController {
  final Logger logger = AppLogger.getLogger((AuthController).toString());
  final AuthRepository repository;

  AuthController({
    required this.repository,
  });

  Option<UserModel> get currentUser => repository.currentUser;

  Future<void> signOut() async {
    await repository.signOut();
  }
}

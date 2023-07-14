import 'package:flutter_firebase_template/common/models/user.dart';
import 'package:flutter_firebase_template/common/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

final authRepository = Provider((ref) => AuthRepository());

class AuthRepository {
  final Logger logger = AppLogger.getLogger((AuthRepository).toString());

  Option<UserModel> get currentUser {
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    logger.d("Signing out user...");
    throw UnimplementedError();
  }
}

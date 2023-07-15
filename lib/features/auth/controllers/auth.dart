import 'package:flutter/material.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/repositories/auth.dart';
import 'package:whatsup/common/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:whatsup/common/util/misc.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    auth: ref.watch(authRepository),
  ),
);

class AuthController {
  final Logger logger = AppLogger.getLogger((AuthController).toString());
  final AuthRepository auth;

  AuthController({
    required this.auth,
  });

  void sendOTP({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    await auth.sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: (id) => {},
      onError: (error) => showSnackbar(context, error),
      onSuccess: () => {},
    );
  }

  Option<UserModel> get currentUser => auth.currentUser;

  Future<void> signOut() async {
    await auth.signOut();
  }
}

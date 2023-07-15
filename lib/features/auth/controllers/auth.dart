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
    auth: ref.read(authRepositoryProvider),
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
    required String otpVerificationPage,
  }) async {
    await auth.sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: (id) => {
        Navigator.pushNamed(context, otpVerificationPage, arguments: id),
      },
      onError: (error) => showSnackbar(context, error),
      onSuccess: () => {},
    );
  }

  void verifyOTP({
    required String idSent,
    required String inputCode,
    required BuildContext context,
    required String createProfileRoute,
  }) async {
    await auth.verifyOTP(
      context: context,
      idSent: idSent,
      inputCode: inputCode,
      onSuccess: () {
        Navigator.pushNamedAndRemoveUntil(context, createProfileRoute, (route) => false);
      },
      onError: (error) => showSnackbar(context, error),
    );
  }

  Option<UserModel> get currentUser => auth.currentUser;

  Future<void> signOut() async {
    await auth.signOut();
  }
}

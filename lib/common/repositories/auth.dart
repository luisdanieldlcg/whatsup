import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:whatsup/main.dart';

final authRepository = Provider((ref) {
  return AuthRepository(auth: ref.watch(authProvider));
});

class AuthRepository {
  final Logger logger = AppLogger.getLogger((AuthRepository).toString());
  final FirebaseAuth _auth;

  AuthRepository({
    required FirebaseAuth auth,
  }) : _auth = auth;

  Option<UserModel> get currentUser {
    return Option.fromNullable(_auth.currentUser).map((user) => UserModel(id: user.uid));
  }

  Future<void> sendOTP({
    required String phoneNumber,
    required VoidCallback onSuccess,
    required Function(String verificationId) onCodeSent,
    required Function(String err) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
          onSuccess();
        },
        verificationFailed: (err) {
          onError(_getOtpErrorMsg(err.code));
        },
        codeSent: (id, resendToken) => onCodeSent(id),
        codeAutoRetrievalTimeout: (id) {},
      );
    } on FirebaseAuthException catch (e) {
      onError(_getOtpErrorMsg(e.code));
    } catch (e) {
      onError(_getOtpErrorMsg(e.toString()));
    }
  }

  Future<void> verifyOTP({
    required BuildContext context,
    required String idSent,
    required String inputCode,
    required VoidCallback onSuccess,
    required Function(String err) onError,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: idSent,
        smsCode: inputCode,
      );
      await _auth.signInWithCredential(credential);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(_getOtpErrorMsg(e.code));
    } catch (e) {
      onError(_getOtpErrorMsg(e.toString()));
    }
  }

  String _getOtpErrorMsg(String code) {
    String message = "Something went wrong";
    logger.e("Error code: $code");
    switch (code) {
      case "account-exists-with-different-credential":
        message = "There is already an account with this phone number";
        break;
      case "operation-not-allowed":
        message = "Phone auth is not enabled";
        break;
      default:
        message = "Failed to verify phone number. Please try again";
        break;
    }
    return message;
  }

  Future<void> signOut() async {
    logger.d("Signing out user...");
    throw UnimplementedError();
  }
}

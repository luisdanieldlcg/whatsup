import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/repositories/auth.dart';
import 'package:whatsup/common/repositories/storage.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/logger.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(
      db: ref.read(dbProvider), ref: ref, authRepository: ref.read(authRepositoryProvider));
});

class UserRepository {
  final FirebaseFirestore _db;
  final AuthRepository _authRepository;
  final Ref _ref;
  static final logger = AppLogger.getLogger((UserRepository).toString());
  const UserRepository({
    required FirebaseFirestore db,
    required AuthRepository authRepository,
    required Ref ref,
  })  : _db = db,
        _authRepository = authRepository,
        _ref = ref;

  Future<void> create({
    required String name,
    required Option<File> avatar,
    required Function(String err) onError,
    required VoidCallback onSuccess,
  }) async {
    try {
      final user = _authRepository.currentUser;
      if (user.isNone()) return;
      final userId = user.unwrap();
      String profileImage = await avatar.match(
        () async => kDefaultAvatarUrl,
        (file) async {
          final url = await _ref.read(storageRepositoryProvider).uploadImage(
                path: "users/${userId.uid}/avatar",
                file: avatar.unwrap(),
              );
          return url;
        },
      );
      final newUser = UserModel(
        uid: userId.uid,
        name: name,
        profileImage: profileImage,
      );
      _db.collection("users").doc(newUser.uid).set(newUser.toMap());
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(_mapError(e.code));
    } catch (e) {
      onError(_mapError(e.toString()));
    }
  }

  String _mapError(String code) {
    logger.e("Error code: $code");
    switch (code) {
      default:
        return "Something went wrong";
    }
  }
}

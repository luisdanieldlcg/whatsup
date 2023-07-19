import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsup/common/enum/status.dart';
import 'package:whatsup/common/models/status.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/repositories/auth.dart';
import 'package:whatsup/common/repositories/storage.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/logger.dart';
import 'package:whatsup/features/contact/repository/contact.dart';

final statusRepositoryProvider = Provider((ref) {
  return StatusRepository(
    db: ref.read(userRepositoryProvider),
    auth: ref.read(authRepositoryProvider),
    ref: ref,
  );
});

class StatusRepository {
  final UserRepository _db;
  final AuthRepository _auth;
  final Ref _ref;
  static final Logger _logger = AppLogger.getLogger((StatusRepository).toString());

  const StatusRepository({
    required UserRepository db,
    required AuthRepository auth,
    required Ref ref,
  })  : _db = db,
        _auth = auth,
        _ref = ref;

  Future<void> uploadTextStatus({
    required String username,
    required String phoneNumber,
    required String profileImage,
    required StatusText text,
    required VoidCallback onError,
  }) async {
    try {
      _logger.d("Attempting to upload text status");
      final String activeUser = _auth.currentUser.unwrap().uid;
      final contacts = await _ref.read(contactRepositoryProvider).getAll();
      final statusId = const Uuid().v4();

      final List<String> whitelist = [];

      for (Contact entry in contacts) {
        final userModel = await _db.users
            .where(kPhoneNumberField, isEqualTo: entry.phones[0].normalizedNumber)
            .get();
        if (userModel.docs.isNotEmpty) {
          final UserModel model = userModel.docs[0].data();
          whitelist.add(model.uid);
        }

        Map<String, int> texts = {};

        final existingStatuses = await _db.userStatuses(activeUser).get();
        if (existingStatuses.docs.isNotEmpty) {
          // We have an existing status
          final status = existingStatuses.docs[0].data();
          // texts = [...status.texts, text];
          texts = {...status.texts, text.text: text.bgColor.value};
          await _db.statuses.doc(existingStatuses.docs[0].id).update({
            'texts': texts,
            'lastStatus': StatusType.text.name,
          });
          return;
        } else {
          // We don't have an existing status
          texts = {
            text.text: text.bgColor.value,
          };
        }

        final status = StatusModel(
          uid: activeUser,
          username: username,
          phoneNumber: phoneNumber,
          photoUrl: [],
          createdAt: DateTime.now(),
          profileImage: profileImage,
          statusId: statusId,
          texts: texts,
          whitelist: whitelist,
          lastStatus: StatusType.text,
        );
        return _db.statuses.doc(statusId).set(status);
      }
    } catch (e, stack) {
      _logger.e(e);
      _logger.e(stack);
      onError();
    }
  }

  Future<void> uploadFileStatus({
    required String username,
    required File statusImage,
    required String phoneNumber,
    required String profileImage,
    required VoidCallback onError,
  }) async {
    try {
      _logger.d("Attempting to upload file status");
      final statusId = const Uuid().v4();
      final String activeUser = _auth.currentUser.unwrap().uid;
      final String url = await _ref.read(storageRepositoryProvider).uploadFile(
            path: '/status/$statusId$activeUser',
            file: statusImage,
          );
      final contacts = await _ref.read(contactRepositoryProvider).getAll();

      final List<String> whitelist = [];
      for (Contact entry in contacts) {
        // Check if the contact is registered on the app
        final phone = entry.phones[0].normalizedNumber;
        final userModel = await _db.users.where(kPhoneNumberField, isEqualTo: phone).get();
        if (userModel.docs.isNotEmpty) {
          final UserModel model = userModel.docs[0].data();
          whitelist.add(model.uid);
        }

        List<String> statusUrls = [];
        final existingStatuses = await _db.userStatuses(activeUser).get();

        if (existingStatuses.docs.isNotEmpty) {
          // We have an existing status
          final status = existingStatuses.docs[0].data();
          statusUrls = [...status.photoUrl, url];
          await _db.statuses.doc(existingStatuses.docs[0].id).update({
            'photoUrl': statusUrls,
            'lastStatus': StatusType.image.name,
          });
          return;
        } else {
          // We don't have an existing status
          statusUrls = [url];
        }

        final status = StatusModel(
          uid: activeUser,
          username: username,
          phoneNumber: phoneNumber,
          photoUrl: statusUrls,
          createdAt: DateTime.now(),
          profileImage: profileImage,
          statusId: statusId,
          texts: {},
          whitelist: whitelist,
          lastStatus: StatusType.image,
        );

        await _db.statuses.doc(statusId).set(status);
      }
    } catch (e) {
      _logger.e(e);
      onError();
    }
  }

  Stream<List<StatusModel>> userStatus() {
    final String activeUser = _auth.currentUser.unwrap().uid;
    return _db.userStatuses(activeUser).snapshots().map((query) {
      return query.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<List<StatusModel>> getStatus() async {
    final List<StatusModel> status = [];
    try {
      final contacts = await _ref.read(contactRepositoryProvider).getAll();
      for (Contact entry in contacts) {
        final phone = entry.phones[0].normalizedNumber;
        final statuses = await _db.statuses.where(kPhoneNumberField, isEqualTo: phone).get();
        final availableStatuses = statuses.docs
            .map((query) => query.data())
            .filter((status) => status.whitelist.contains(_auth.currentUser.unwrap().uid));
        status.addAll(availableStatuses);
      }
    } catch (e, stack) {
      _logger.e(e.toString());
      _logger.e(stack);
    }
    return status;
  }
}

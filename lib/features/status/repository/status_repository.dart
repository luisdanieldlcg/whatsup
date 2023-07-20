import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/features/contact/repository/contact.dart';
import 'package:async/async.dart';

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

  Future<void> markSeenByCurrentUser({
    required String statusId,
    required String userPhoneNumber,
  }) async {
    try {
      await _db.statuses.doc(statusId).update({
        'seenBy': FieldValue.arrayUnion([userPhoneNumber]),
      });
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> deleteUserStatus({
    required String statusId,
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    try {
      await _db.statuses.doc(statusId).delete();
      onSuccess();
    } catch (e, trace) {
      _logger.e(e);
      _logger.d(trace);
      onError();
    }
  }

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
        // had to do it this way due to ios returning empty normalized number
        final phone = removePhoneDecoration((entry.phones[0].normalizedNumber.isEmpty
            ? entry.phones[0].number
            : entry.phones[0].normalizedNumber));
        final userModel = await _db.users.where(kPhoneNumberField, isEqualTo: phone).get();
        if (userModel.docs.isNotEmpty) {
          final UserModel model = userModel.docs[0].data();
          whitelist.add(model.uid);
        }

        final existingStatuses = await _db.userStatuses(activeUser).get();
        if (existingStatuses.docs.isNotEmpty) {
          // We have an existing status
          final status = existingStatuses.docs[0].data();
          await _db.statuses.doc(existingStatuses.docs[0].id).update({
            'texts': {
              ...status.texts,
              text.text: text.bgColor.value,
            },
            'lastStatus': StatusType.text.name.toString(),
          });
          return;
        }
      }
      // We don't have an existing status
      final status = StatusModel(
        uid: activeUser,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: [],
        createdAt: DateTime.now(),
        profileImage: profileImage,
        statusId: statusId,
        texts: {
          text.text: text.bgColor.value,
        },
        whitelist: whitelist,
        lastStatus: StatusType.text,
        seenBy: const [],
      );
      return _db.statuses.doc(statusId).set(status);
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
        final phone = removePhoneDecoration((entry.phones[0].normalizedNumber.isEmpty
            ? entry.phones[0].number
            : entry.phones[0].normalizedNumber));
        final userModel = await _db.users.where(kPhoneNumberField, isEqualTo: phone).get();
        if (userModel.docs.isNotEmpty) {
          final UserModel model = userModel.docs[0].data();
          whitelist.add(model.uid);
        }

        final existingStatuses = await _db.userStatuses(activeUser).get();

        if (existingStatuses.docs.isNotEmpty) {
          // We have an existing status
          final status = existingStatuses.docs[0].data();
          await _db.statuses.doc(existingStatuses.docs[0].id).update({
            'photoUrl': [...status.photoUrl, url],
            'lastStatus': StatusType.image.name.toString(),
          });
          return;
        }
      }

      final status = StatusModel(
        uid: activeUser,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: [url],
        createdAt: DateTime.now(),
        profileImage: profileImage,
        statusId: statusId,
        texts: {},
        whitelist: whitelist,
        lastStatus: StatusType.image,
        seenBy: const [],
      );

      await _db.statuses.doc(statusId).set(status);
    } catch (e) {
      _logger.e(e);
      onError();
    }
  }

  Stream<Option<StatusModel>> userStatus() {
    final String activeUser = _auth.currentUser.unwrap().uid;
    return _db.userStatuses(activeUser).snapshots().map((query) {
      if (query.docs.isEmpty) {
        return none();
      }
      return some(query.docs[0].data());
    });
  }

  Stream<List<StatusModel>> getContactStatus(List<Contact> userContacts) {
    final List<String> whitelist = [];
    // consider filter out contacts that are registered not on the app or I blocked
    // as a future feature.
    for (Contact entry in userContacts) {
      whitelist.add(entry.phones[0].normalizedNumber);
    }
    if (whitelist.isEmpty) {
      return Stream.value([]);
    }

    final List<Stream<List<StatusModel>>> statuses = [];

    for (String contactPhone in whitelist) {
      final Stream<List<StatusModel>> contactStatus =
          _db.statuses.where(kPhoneNumberField, isEqualTo: contactPhone).snapshots().map((query) {
        return query.docs
            .map((status) => status.data())
            .filter((t) => t.whitelist.contains(_auth.currentUser.unwrap().uid))
            .toList();
      });
      statuses.add(contactStatus);
    }

    final streamGroup = StreamGroup<List<StatusModel>>();
    for (Stream<List<StatusModel>> statusStream in statuses) {
      streamGroup.add(statusStream);
    }
    return streamGroup.stream;
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

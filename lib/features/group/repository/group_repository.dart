import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsup/common/models/group.dart';
import 'package:whatsup/common/repositories/storage.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/logger.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(
    db: ref.read(userRepositoryProvider),
    ref: ref,
  );
});

class GroupRepository {
  final UserRepository _db;
  final Ref _ref;
  static final _logger = AppLogger.getLogger((GroupRepository).toString());

  const GroupRepository({
    required UserRepository db,
    required Ref ref,
  })  : _db = db,
        _ref = ref;

  Future<void> createGroup({
    required String name,
    required List<Contact> selectedContacts,
    required Option<File> groupImage,
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    try {
      final String currentUserId = _db.activeUser.unwrap().uid;
      final List<String> members = [];
      for (Contact entry in selectedContacts) {
        final query = await _db.users
            .where(kPhoneNumberField, isEqualTo: entry.phones[0].normalizedNumber)
            .get();
        if (query.docs.isNotEmpty && query.docs[0].exists) {
          members.add(query.docs[0].id);
        }
      }

      final groupId = const Uuid().v4();

      final profileImage = await groupImage.match(
        () async => kDefaultGroupAvatarUrl,
        (file) async {
          return await _ref.read(storageRepositoryProvider).uploadFile(
                path: 'group/$groupId',
                file: file,
              );
        },
      );
      final group = GroupModel(
        name: name,
        groupId: groupId,
        groupImage: profileImage,
        lastMessage: '',
        lastSenderId: currentUserId,
        lastMessageTime: DateTime.now(),
        members: [
          currentUserId,
          ...members,
        ],
      );
      await _db.groups.doc(groupId).set(group);
      onSuccess();
    } catch (e) {
      _logger.e(e.toString());
      onError();
    }
  }
}

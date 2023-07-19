import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsup/common/models/status.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/features/contact/repository/contact.dart';
import 'package:whatsup/features/status/repository/status_repository.dart';

final statusControllerProvider = Provider((ref) {
  return StatusController(
    statusRepository: ref.read(statusRepositoryProvider),
    ref: ref,
  );
});

final getStatusProvider = FutureProvider<List<StatusModel>>((ref) async {
  return await ref.watch(statusControllerProvider).getStatus();
});

final userStatusStreamProvider = StreamProvider<Option<StatusModel>>((ref) {
  return ref.watch(statusRepositoryProvider).userStatus();
});
final contactStatusStreamProvider =
    StreamProvider.family<List<StatusModel>, List<Contact>>((ref, contacts) {
  return ref.watch(statusRepositoryProvider).getContactStatus(contacts);
});

class StatusController {
  final StatusRepository _statusRepository;
  final Ref _ref;

  const StatusController({required StatusRepository statusRepository, required Ref ref})
      : _statusRepository = statusRepository,
        _ref = ref;

  void markSeenByCurrentUser({
    required String statusId,
  }) {
    _ref.read(userFetchProvider).whenData((value) async {
      if (value.isSome()) {
        final user = value.unwrap();
        _statusRepository.markSeenByCurrentUser(
          statusId: statusId,
          userPhoneNumber: user.phoneNumber,
        );
      }
    });
  }

  void deleteUserStatus(String statusId, BuildContext context) {
    _statusRepository.deleteUserStatus(
      statusId: statusId,
      onError: () => {},
      onSuccess: () => {},
    );
  }

  void uploadFileStatus({
    required File statusImage,
    required BuildContext context,
  }) async {
    _ref.read(userFetchProvider).whenData((value) async {
      if (value.isSome()) {
        final user = value.unwrap();
        _statusRepository.uploadFileStatus(
          username: user.name,
          statusImage: statusImage,
          phoneNumber: user.phoneNumber,
          profileImage: user.profileImage,
          onError: () => showSnackbar(context, "Failed to upload status. Try again."),
        );
      }
    });
  }

  void uploadTextStatus({
    required StatusText text,
    required BuildContext context,
  }) async {
    _ref.read(userFetchProvider).whenData((value) async {
      if (value.isSome()) {
        final user = value.unwrap();
        _statusRepository.uploadTextStatus(
          username: user.name,
          text: text,
          phoneNumber: user.phoneNumber,
          profileImage: user.profileImage,
          onError: () => showSnackbar(context, "Failed to upload status. Try again."),
        );
      }
    });
  }

  Future<List<StatusModel>> getStatus() async {
    return await _statusRepository.getStatus();
  }
}

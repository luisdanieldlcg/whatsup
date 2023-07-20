import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/features/group/repository/group_repository.dart';

final groupControllerProvider = Provider<GroupController>(
  (ref) => GroupController(
    groupRepository: ref.watch(groupRepositoryProvider),
    ref: ref,
  ),
);

class GroupController {
  final GroupRepository _groupRepository;
  final Ref _ref;

  const GroupController({
    required GroupRepository groupRepository,
    required Ref ref,
  })  : _groupRepository = groupRepository,
        _ref = ref;

  void createGroup({
    required BuildContext context,
    required String name,
    required Option<File> groupImage,
    required List<Contact> selectedContacts,
  }) async {
    _groupRepository.createGroup(
      name: name,
      selectedContacts: selectedContacts,
      groupImage: groupImage,
      onError: () => showSnackbar(context, "Failed to create group"),
      onSuccess: () {},
    );
  }
}

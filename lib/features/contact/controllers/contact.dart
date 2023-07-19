import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/features/contact/repository/contact.dart';

final readAllContactsProvider = FutureProvider((ref) {
  return ref.watch(contactRepositoryProvider).getAll();
});

final selectContactProvider = Provider((ref) {
  return SelectContactController(
    userRepository: ref.read(userRepositoryProvider),
    contactRepository: ref.read(contactRepositoryProvider),
  );
});

class SelectContactController {
  final UserRepository userRepository;
  final ContactRepository contactRepository;

  const SelectContactController({
    required this.userRepository,
    required this.contactRepository,
  });

  void findContact({
    required Contact selected,
    required VoidCallback contactNotFound,
    required Function(UserModel user) contactFound,
  }) async {
    String phone = selected.phones[0].number
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '');

    // make sure the phone starts with +
    if (!phone.startsWith('+')) {
      phone = '+$phone';
    }
    final query = userRepository.users.where(kPhoneNumberField, isEqualTo: phone).limit(1).get();
    final snapshot = await query;
    if (snapshot.docs.isEmpty) {
      return contactNotFound();
    }
    // This should not happen anyway
    if (snapshot.docs[0].data().phoneNumber != phone) {
      return contactNotFound();
    }
    contactFound(snapshot.docs[0].data());
  }
}

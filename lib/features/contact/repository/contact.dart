import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/logger.dart';

final contactRepositoryProvider = Provider((ref) {
  return ContactRepository(db: ref.read(userRepositoryProvider));
});

class ContactRepository {
  final logger = AppLogger.getLogger((ContactRepository).toString());
  final UserRepository _db;

  ContactRepository({
    required UserRepository db,
  }) : _db = db;

  Future<List<Contact>> getAll() async {
    try {
      if (!await FlutterContacts.requestPermission()) return [];
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      contacts.removeWhere((contact) => contact.phones.isEmpty);
      return contacts;
    } catch (e) {
      logger.e(e);
    }
    return [];
  }
}

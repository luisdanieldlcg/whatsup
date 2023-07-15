import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/util/logger.dart';

final contactRepositoryProvider = Provider((ref) {
  return ContactRepository(db: ref.read(dbProvider));
});

class ContactRepository {
  final logger = AppLogger.getLogger((ContactRepository).toString());
  final FirebaseFirestore _db;

  ContactRepository({
    required FirebaseFirestore db,
  }) : _db = db;

  Future<List<Contact>> getAll() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
      }
    } catch (e) {
      logger.e(e);
    }
    return contacts;
  }
}

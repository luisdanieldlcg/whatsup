import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/providers.dart';

final storageRepositoryProvider = Provider((ref) {
  return StorageRepository(storage: ref.read(storageProvider));
});

class StorageRepository {
  final FirebaseStorage _storage;

  const StorageRepository({
    required FirebaseStorage storage,
  }) : _storage = storage;

  Future<String> uploadFile({
    required String path,
    required File file,
  }) async {
    final snapshot = await _storage.ref().child(path).putFile(file);
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}

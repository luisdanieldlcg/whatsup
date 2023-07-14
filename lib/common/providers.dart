import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = Provider((_) => FirebaseAuth.instance);
final dbProvider = Provider((_) => FirebaseFirestore.instance);
final storageProvider = Provider((_) => FirebaseStorage.instance);

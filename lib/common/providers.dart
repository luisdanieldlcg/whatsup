import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsup/common/enum/message.dart';

final authProvider = Provider((_) => FirebaseAuth.instance);
final dbProvider = Provider((_) => FirebaseFirestore.instance);
final storageProvider = Provider((_) => FirebaseStorage.instance);
final messageReplyProvider = StateProvider<Option<MessageReply>>((ref) => const Option.none());

class MessageReply {
  final String repliedTo;
  final String message;
  // whether this message is sent by the current user
  final bool isSenderMessage;
  final MessageType type;

  const MessageReply({
    required this.repliedTo,
    required this.message,
    required this.isSenderMessage,
    required this.type,
  });
}

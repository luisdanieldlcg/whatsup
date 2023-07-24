import 'dart:convert';

import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/util/ext.dart';

class MessageModel {
  final String uid;
  final String senderId;
  final String recvId;
  final String message;
  final String repliedMessage;
  final String repliedTo;
  final MessageType repliedMessageType;
  final MessageType type;
  final DateTime timeSent;
  final bool isRead;

  const MessageModel({
    required this.uid,
    required this.senderId,
    required this.recvId,
    required this.message,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
    required this.type,
    required this.timeSent,
    required this.isRead,
  });

  MessageModel copyWith({
    String? uid,
    String? senderId,
    String? recvId,
    String? message,
    String? repliedMessage,
    String? repliedTo,
    MessageType? repliedMessageType,
    MessageType? type,
    DateTime? timeSent,
    bool? isRead,
  }) {
    return MessageModel(
      uid: uid ?? this.uid,
      senderId: senderId ?? this.senderId,
      recvId: recvId ?? this.recvId,
      message: message ?? this.message,
      repliedMessage: repliedMessage ?? this.repliedMessage,
      repliedTo: repliedTo ?? this.repliedTo,
      repliedMessageType: repliedMessageType ?? this.repliedMessageType,
      type: type ?? this.type,
      timeSent: timeSent ?? this.timeSent,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'senderId': senderId,
      'recvId': recvId,
      'message': message,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      uid: map['uid'] as String,
      senderId: map['senderId'] as String,
      recvId: map['recvId'] as String,
      message: map['message'] as String,
      repliedMessage: map['repliedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: (map['repliedMessageType'] as String).intoChatMessage(),
      type: (map['type'] as String).intoChatMessage(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      isRead: map['isRead'] as bool,
    );
  }

  @override
  String toString() {
    return 'MessageModel(uid: $uid, senderId: $senderId, recvId: $recvId, message: $message, repliedMessage: $repliedMessage, repliedTo: $repliedTo, repliedMessageType: $repliedMessageType, type: $type, timeSent: $timeSent, isRead: $isRead)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.senderId == senderId &&
        other.recvId == recvId &&
        other.message == message &&
        other.repliedMessage == repliedMessage &&
        other.repliedTo == repliedTo &&
        other.repliedMessageType == repliedMessageType &&
        other.type == type &&
        other.timeSent == timeSent &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        senderId.hashCode ^
        recvId.hashCode ^
        message.hashCode ^
        repliedMessage.hashCode ^
        repliedTo.hashCode ^
        repliedMessageType.hashCode ^
        type.hashCode ^
        timeSent.hashCode ^
        isRead.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

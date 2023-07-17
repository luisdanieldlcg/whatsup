import 'package:whatsup/common/enum/message.dart';
import 'package:whatsup/common/util/ext.dart';

class MessageModel {
  final String uid;
  final String senderId;
  final String recvId;
  final String message;
  final ChatMessageType type;
  final DateTime timeSent;
  final bool isRead;

  const MessageModel({
    required this.uid,
    required this.senderId,
    required this.recvId,
    required this.message,
    required this.type,
    required this.timeSent,
    required this.isRead,
  });

  MessageModel copyWith({
    String? uid,
    String? senderId,
    String? recvId,
    String? message,
    ChatMessageType? type,
    DateTime? timeSent,
    bool? isRead,
  }) {
    return MessageModel(
      uid: uid ?? this.uid,
      senderId: senderId ?? this.senderId,
      recvId: recvId ?? this.recvId,
      message: message ?? this.message,
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
      type: (map['type'] as String).intoChatMessage(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      isRead: map['isRead'] as bool,
    );
  }

  @override
  String toString() {
    return 'Message(uid: $uid, senderId: $senderId, recvId: $recvId, message: $message, type: $type, timeSent: $timeSent, isRead: $isRead)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.senderId == senderId &&
        other.recvId == recvId &&
        other.message == message &&
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
        type.hashCode ^
        timeSent.hashCode ^
        isRead.hashCode;
  }
}

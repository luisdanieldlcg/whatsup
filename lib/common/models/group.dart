import 'package:flutter/foundation.dart';

class GroupModel {
  final String name;
  final String groupId;
  final String groupImage;
  final String lastMessage;
  final String lastSenderId;
  final DateTime lastMessageTime;
  final List<String> members;

  const GroupModel({
    required this.name,
    required this.groupId,
    required this.groupImage,
    required this.lastMessage,
    required this.lastSenderId,
    required this.lastMessageTime,
    required this.members,
  });

  GroupModel copyWith({
    String? name,
    String? groupId,
    String? groupImage,
    String? lastUserImage,
    String? lastMessage,
    String? lastSenderId,
    DateTime? lastMessageTime,
    List<String>? members,
  }) {
    return GroupModel(
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      groupImage: groupImage ?? this.groupImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'groupId': groupId,
      'groupImage': groupImage,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'members': members,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      groupImage: map['groupImage'] as String,
      lastMessage: map['lastMessage'] as String,
      lastSenderId: map['lastSenderId'] as String,
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime'] as int),
      members: List<String>.from(map['members'] as List<dynamic>),
    );
  }

  @override
  String toString() {
    return 'GroupModel(name: $name, groupId: $groupId, groupImage: $groupImage, lastMessage: $lastMessage, lastSenderId: $lastSenderId, lastMessageTime: $lastMessageTime, members: $members)';
  }

  @override
  bool operator ==(covariant GroupModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.groupId == groupId &&
        other.groupImage == groupImage &&
        other.lastMessage == lastMessage &&
        other.lastSenderId == lastSenderId &&
        other.lastMessageTime == lastMessageTime &&
        listEquals(other.members, members);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        groupId.hashCode ^
        groupImage.hashCode ^
        lastMessage.hashCode ^
        lastSenderId.hashCode ^
        lastMessageTime.hashCode ^
        members.hashCode;
  }
}

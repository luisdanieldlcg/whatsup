import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/common/enum/status.dart';
import 'package:whatsup/common/util/ext.dart';

class StatusText {
  final String text;
  final Color bgColor;

  const StatusText({
    required this.text,
    required this.bgColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'bgColor': bgColor.value,
    };
  }

  factory StatusText.fromMap(Map<String, dynamic> map) {
    return StatusText(
      text: map['text'],
      bgColor: Color(map['bgColor']),
    );
  }
}

class StatusModel {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final Map<String, int> texts;
  final DateTime createdAt;
  final String profileImage;
  final String statusId;
  final List<String> whitelist;
  final StatusType lastStatus;
  final List<String> seenBy;

  const StatusModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.texts,
    required this.createdAt,
    required this.profileImage,
    required this.statusId,
    required this.whitelist,
    required this.lastStatus,
    required this.seenBy,
  });

  StatusModel copyWith({
    String? uid,
    String? username,
    String? phoneNumber,
    List<String>? photoUrl,
    Map<String, int>? texts,
    DateTime? createdAt,
    String? profileImage,
    String? statusId,
    List<String>? whitelist,
    StatusType? lastStatus,
  }) {
    return StatusModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      texts: texts ?? this.texts,
      createdAt: createdAt ?? this.createdAt,
      profileImage: profileImage ?? this.profileImage,
      statusId: statusId ?? this.statusId,
      whitelist: whitelist ?? this.whitelist,
      lastStatus: lastStatus ?? this.lastStatus,
      seenBy: seenBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'texts': texts,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profileImage': profileImage,
      'statusId': statusId,
      'whitelist': whitelist,
      'lastStatus': lastStatus.name.toString(),
      'seenBy': seenBy,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    final photos = map['photoUrl'] as List<dynamic>;
    // final texts = map['texts'] as List<dynamic>;
    final whitelist = map['whitelist'] as List<dynamic>;
    final seenBy = map['seenBy'] as List<dynamic>;

    final photosAsString = photos.map((e) => e as String).toList();
    final whitelistAsString = whitelist.map((e) => e as String).toList();
    final seenByAsString = seenBy.map((e) => e as String).toList();
    return StatusModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: photosAsString,
      texts: Map<String, int>.from((map['texts'] as Map<String, dynamic>)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      profileImage: map['profileImage'] as String,
      statusId: map['statusId'] as String,
      whitelist: whitelistAsString,
      lastStatus: (map['lastStatus'] as String).intoStatus(),
      seenBy: seenByAsString,
    );
  }

  @override
  String toString() {
    return 'StatusModel(uid: $uid, username: $username, phoneNumber: $phoneNumber, photoUrl: $photoUrl, texts: $texts, createdAt: $createdAt, profileImage: $profileImage, statusId: $statusId, whitelist: $whitelist, lastStatus: $lastStatus, seenBy: $seenBy)';
  }

  @override
  bool operator ==(covariant StatusModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.username == username &&
        other.phoneNumber == phoneNumber &&
        listEquals(other.photoUrl, photoUrl) &&
        mapEquals(other.texts, texts) &&
        other.createdAt == createdAt &&
        other.profileImage == profileImage &&
        other.statusId == statusId &&
        listEquals(other.whitelist, whitelist);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        username.hashCode ^
        phoneNumber.hashCode ^
        photoUrl.hashCode ^
        texts.hashCode ^
        createdAt.hashCode ^
        profileImage.hashCode ^
        statusId.hashCode ^
        whitelist.hashCode;
  }
}

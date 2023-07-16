import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String uid;
  final String name;
  final String profileImage;
  final String phoneNumber;
  final bool isOnline;

  const UserModel({
    required this.uid,
    required this.name,
    required this.profileImage,
    required this.phoneNumber,
    required this.isOnline,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profileImage,
    String? phoneNumber,
    bool? isOnline,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profileImage: map['profileImage'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isOnline: map['isOnline'] as bool,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profileImage: $profileImage, phoneNumber: $phoneNumber, isOnline: $isOnline)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.profileImage == profileImage &&
        other.phoneNumber == phoneNumber &&
        other.isOnline == isOnline;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        profileImage.hashCode ^
        phoneNumber.hashCode ^
        isOnline.hashCode;
  }
}

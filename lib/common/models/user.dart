import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String uid;
  final String name;
  final String profileImage;
  final String phoneNumber;

  const UserModel({
    required this.uid,
    required this.name,
    required this.profileImage,
    required this.phoneNumber,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profileImage,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profileImage: map['profileImage'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profileImage: $profileImage, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.profileImage == profileImage &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ name.hashCode ^ profileImage.hashCode ^ phoneNumber.hashCode;
  }
}

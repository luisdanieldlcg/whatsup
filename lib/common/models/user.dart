import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String uid;
  final String name;
  final String profileImage;

  const UserModel({
    required this.uid,
    required this.name,
    required this.profileImage,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profileImage,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'uid': uid,
      'name': name,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profileImage: map['profileImage'] as String,
    );
  }

  @override
  String toString() => 'UserModel(uid: $uid, name: $name, profileImage: $profileImage)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.name == name && other.profileImage == profileImage;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ profileImage.hashCode;
}

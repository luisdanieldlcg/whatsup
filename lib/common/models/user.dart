import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String id;

  const UserModel({
    required this.id,
  });

  UserModel copyWith({
    String? id,
  }) {
    return UserModel(
      id: id ?? this.id,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
    );
  }

  @override
  String toString() => 'UserModel(id: $id)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

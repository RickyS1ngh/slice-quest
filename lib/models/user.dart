import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String username;
  final String uid;
  final String profileImage;
  final List completedQuests;
  final int xp;
  UserModel({
    required this.username,
    required this.uid,
    required this.profileImage,
    required this.completedQuests,
    required this.xp,
  });

  UserModel copyWith({
    String? username,
    String? uuid,
    String? profileImage,
    List? completedQuests,
    int? xp,
  }) {
    return UserModel(
      username: username ?? this.username,
      uid: uuid ?? this.uid,
      profileImage: profileImage ?? this.profileImage,
      completedQuests: completedQuests ?? this.completedQuests,
      xp: xp ?? this.xp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'uid': uid,
      'profileImage': profileImage,
      'completedQuests': completedQuests,
      'xp': xp,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      uid: map['uid'] as String,
      profileImage: map['profileImage'] as String,
      completedQuests: List.from(map['completedQuests'] as List),
      xp: map['xp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(username: $username, uuid: $uid, profileImage: $profileImage, completedQuests: $completedQuests, xp: $xp)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.uid == uid &&
        other.profileImage == profileImage &&
        listEquals(other.completedQuests, completedQuests) &&
        other.xp == xp;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        uid.hashCode ^
        profileImage.hashCode ^
        completedQuests.hashCode ^
        xp.hashCode;
  }
}

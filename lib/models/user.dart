import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String email;
  final String username;
  final String uid;
  final String profileImage;
  final List<String> completedQuests;
  final int xp;
  final String activeQuest;
  final List<String> reviews;
  UserModel(
      {required this.email,
      required this.username,
      required this.uid,
      required this.profileImage,
      required this.completedQuests,
      required this.xp,
      required this.activeQuest,
      required this.reviews});

  UserModel copyWith({
    String? email,
    String? username,
    String? uid,
    String? profileImage,
    List<String>? completedQuests,
    int? xp,
    String? activeQuest,
    List<String>? reviews,
  }) {
    return UserModel(
        email: email ?? this.email,
        username: username ?? this.username,
        uid: uid ?? this.uid,
        profileImage: profileImage ?? this.profileImage,
        completedQuests: completedQuests ?? this.completedQuests,
        xp: xp ?? this.xp,
        activeQuest: activeQuest ?? this.activeQuest,
        reviews: reviews ?? this.reviews);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'uid': uid,
      'profileImage': profileImage,
      'completedQuests': completedQuests,
      'xp': xp,
      'activeQuest': activeQuest,
      'reviews': reviews
    };
  }

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return UserModel(
      email: data!['email'],
      username: data['username'],
      uid: doc.id,
      profileImage: data['profileImage'],
      completedQuests: (data['completedQuests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      xp: data['xp'],
      activeQuest: data['activeQuest'] ?? null,
      reviews: (data['reviews'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      username: map['username'] as String,
      uid: map['uid'] as String,
      profileImage: map['profileImage'] as String,
      completedQuests: List.from(map['completedQuests'] as List),
      xp: map['xp'] as int,
      activeQuest: map['activeQuest'] as String,
      reviews: List.from(map['reviews'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, username: $username, uid: $uid, profileImage: $profileImage, completedQuests: $completedQuests, xp: $xp, activeQuest: $activeQuest, reviews: $reviews)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.username == username &&
        other.uid == uid &&
        other.profileImage == profileImage &&
        listEquals(other.completedQuests, completedQuests) &&
        other.xp == xp &&
        other.activeQuest == activeQuest &&
        listEquals(other.reviews, reviews);
  }

  @override
  int get hashCode {
    return email.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        profileImage.hashCode ^
        completedQuests.hashCode ^
        xp.hashCode ^
        activeQuest.hashCode ^
        reviews.hashCode;
  }
}

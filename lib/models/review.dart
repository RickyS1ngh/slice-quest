// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ReviewModel {
  String uuid;
  final String image;
  final double rating;
  final String comment;
  final String username;
  final String questID;
  ReviewModel({
    String? uuid,
    required this.image,
    required this.rating,
    required this.comment,
    required this.username,
    required this.questID,
  }) : uuid = uuid ?? const Uuid().v4();

  ReviewModel copyWith({
    String? uuid,
    String? image,
    double? rating,
    String? comment,
    String? username,
    String? questID,
  }) {
    return ReviewModel(
      uuid: uuid ?? this.uuid,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      username: username ?? this.username,
      questID: questID ?? this.questID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'image': image,
      'rating': rating,
      'comment': comment,
      'username': username,
      'questID': questID,
    };
  }

  factory ReviewModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return ReviewModel(
        image: data!['image'],
        rating: data['rating'],
        comment: data['comment'],
        username: data['username'],
        questID: data['questID']);
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      uuid: map['uuid'] as String,
      image: map['image'] as String,
      rating: map['rating'] as double,
      comment: map['comment'] as String,
      username: map['username'] as String,
      questID: map['questID'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReviewModel(uuid: $uuid, image: $image, rating: $rating, comment: $comment, username: $username, questID: $questID)';
  }

  @override
  bool operator ==(covariant ReviewModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.image == image &&
        other.rating == rating &&
        other.comment == comment &&
        other.username == username &&
        other.questID == questID;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        image.hashCode ^
        rating.hashCode ^
        comment.hashCode ^
        username.hashCode ^
        questID.hashCode;
  }
}

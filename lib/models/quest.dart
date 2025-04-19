// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class QuestModel {
  QuestModel({
    String? uuid,
    required this.name,
    required this.description,
    required this.pizzeriaName,
    required this.location,
    required this.imageName,
    required this.latitude,
    required this.longitude,
    required this.xp,
  }) : uuid = uuid ?? const Uuid().v4();
  final String name;
  final String description;
  final String pizzeriaName;
  final String location;
  final String uuid;
  final String imageName;
  final double latitude;
  final double longitude;
  final int xp;

  QuestModel copyWith({
    String? name,
    String? description,
    String? pizzeriaName,
    String? location,
    String? uuid,
    String? imageName,
    double? latitude,
    double? longitude,
    int? xp,
  }) {
    return QuestModel(
      name: name ?? this.name,
      description: description ?? this.description,
      pizzeriaName: pizzeriaName ?? this.pizzeriaName,
      location: location ?? this.location,
      uuid: uuid ?? this.uuid,
      imageName: imageName ?? this.imageName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      xp: xp ?? this.xp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'pizzeriaName': pizzeriaName,
      'location': location,
      'uuid': uuid,
      'imageName': imageName,
      'latitude': latitude,
      'longitude': longitude,
      'xp': xp,
    };
  }

  factory QuestModel.fromMap(Map<String, dynamic> map) {
    return QuestModel(
      name: map['name'] as String,
      description: map['description'] as String,
      pizzeriaName: map['pizzeriaName'] as String,
      location: map['location'] as String,
      uuid: map['uuid'] as String,
      imageName: map['imageName'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      xp: map['xp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestModel.fromJson(String source) =>
      QuestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuestModel(name: $name, description: $description, pizzeriaName: $pizzeriaName, location: $location, uuid: $uuid, imageName: $imageName, latitude: $latitude, longitude: $longitude, xp: $xp)';
  }

  @override
  bool operator ==(covariant QuestModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.description == description &&
        other.pizzeriaName == pizzeriaName &&
        other.location == location &&
        other.uuid == uuid &&
        other.imageName == imageName &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.xp == xp;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        pizzeriaName.hashCode ^
        location.hashCode ^
        uuid.hashCode ^
        imageName.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        xp.hashCode;
  }
}

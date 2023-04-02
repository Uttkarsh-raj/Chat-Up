// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String name;
  final String email;
  final List<String> contacts;
  final String profiePic;
  final String bannerPic;
  final String uid;
  final String bio;
  const UserModel({
    required this.name,
    required this.email,
    required this.contacts,
    required this.profiePic,
    required this.bannerPic,
    required this.uid,
    required this.bio,
  });

  UserModel copyWith({
    String? name,
    String? email,
    List<String>? contacts,
    String? profiePic,
    String? bannerPic,
    String? uid,
    String? bio,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      contacts: contacts ?? this.contacts,
      profiePic: profiePic ?? this.profiePic,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'contacts': contacts,
      'profiePic': profiePic,
      'bannerPic': bannerPic,
      'bio': bio,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      contacts: List<String>.from(
        (map['contacts'] as List<String>),
      ),
      profiePic: map['profiePic'] as String,
      bannerPic: map['bannerPic'] as String,
      uid: map['\$id'] as String,
      bio: map['bio'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, contacts: $contacts, profiePic: $profiePic, bannerPic: $bannerPic, uid: $uid, bio: $bio)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        listEquals(other.contacts, contacts) &&
        other.profiePic == profiePic &&
        other.bannerPic == bannerPic &&
        other.uid == uid &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        contacts.hashCode ^
        profiePic.hashCode ^
        bannerPic.hashCode ^
        uid.hashCode ^
        bio.hashCode;
  }
}

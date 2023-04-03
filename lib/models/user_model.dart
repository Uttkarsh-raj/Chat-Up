// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String name;
  final String email;
  final List<String> contacts;
  final String bannerPic;
  final String uid;
  final String bio;
  final String profilePic;
  const UserModel({
    required this.name,
    required this.email,
    required this.contacts,
    required this.bannerPic,
    required this.uid,
    required this.bio,
    required this.profilePic,
  });

  UserModel copyWith({
    String? name,
    String? email,
    List<String>? contacts,
    String? bannerPic,
    String? uid,
    String? bio,
    String? profilePic,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      contacts: contacts ?? this.contacts,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'contacts': contacts,
      'bannerpic': bannerPic,
      'bio': bio,
      'profilepic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      contacts: List<String>.from(
        (map['contacts'] as List<String>),
      ),
      bannerPic: map['bannerpic'] as String,
      uid: map['\$id'] as String,
      bio: map['bio'] as String,
      profilePic: map['profilepic'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, contacts: $contacts, bannerpic: $bannerPic, uid: $uid, bio: $bio ,profilepic: $profilePic )';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        listEquals(other.contacts, contacts) &&
        other.bannerPic == bannerPic &&
        other.uid == uid &&
        other.bio == bio &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        contacts.hashCode ^
        bannerPic.hashCode ^
        uid.hashCode ^
        bio.hashCode ^
        profilePic.hashCode;
  }
}

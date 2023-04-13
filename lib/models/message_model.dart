// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageModel {
  final String mId;
  final String receiverId;
  final String senderId;
  final String message;
  final DateTime createdOn;
  MessageModel({
    required this.mId,
    required this.receiverId,
    required this.senderId,
    required this.message,
    required this.createdOn,
  });

  MessageModel copyWith({
    String? mId,
    String? receiverId,
    String? senderId,
    String? message,
    DateTime? createdOn,
  }) {
    return MessageModel(
      mId: mId ?? this.mId,
      receiverId: receiverId ?? this.receiverId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiverId': receiverId,
      'senderId': senderId,
      'message': message,
      'createdOn': createdOn.millisecondsSinceEpoch,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      mId: map['\$mid'] as String,
      receiverId: map['receiverId'] as String,
      senderId: map['senderId'] as String,
      message: map['message'] as String,
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(mId: $mId, receiverId: $receiverId, senderId: $senderId, message: $message, createdOn: $createdOn)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.mId == mId &&
        other.receiverId == receiverId &&
        other.senderId == senderId &&
        other.message == message &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return mId.hashCode ^
        receiverId.hashCode ^
        senderId.hashCode ^
        message.hashCode ^
        createdOn.hashCode;
  }
}

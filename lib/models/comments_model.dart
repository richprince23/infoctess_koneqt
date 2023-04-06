import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String authorID;
  String text;
  DateTime? timestamp;

  Comment({
    required this.id,
    required this.authorID,
    required this.text,
    this.timestamp,
  });

  factory Comment.fromMap(Map data) {
    return Comment(
      id: data['id'] ?? '',
      authorID: data['authorID'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': authorID,
      'text': text,
      'timestamp': timestamp,
    };
  }

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'author': authorID,
        'text': text,
        'timestamp': timestamp,
      };

  // from json
  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        authorID: json['authorID'],
        text: json['text'],
        timestamp: json['timestamp'],
      );

  Comment copyWith({
    String? id,
    String? authorID,
    String? text,
    DateTime? timestamp,
  }) {
    return Comment(
      id: id!,
      authorID: authorID!,
      text: text!,
      timestamp: timestamp,
    );
  }
}
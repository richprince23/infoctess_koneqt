import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoctess_koneqt/models/comments_model.dart';

class PostModel {
  static const ID = 'id';
  static const BODY = 'body';
  static const IMG_URL = 'imgUrl';
  static const TIMESTAMP = 'timestamp';
  static const COMMENTS = 'comments';
  static const LIKES = 'likes';

  String? _id;
  String? _body;
  String? _imgUrl;
  String? _posterID;
  DateTime? _timestamp;
  List<Comment>? _comments;
  List<String>? _likes;

  String? get id => _id;

  String? get body => _body;

  String? get imgUrl => _imgUrl;
  String? get posterID => _posterID;

  DateTime? get timestamp => _timestamp;

  List<Comment>? get comments => _comments;
  List<String>? get likes => _likes ?? [];
}

class Post {
  String id;
  String body;
  String? posterID;
  String? imgUrl;
  DateTime? timestamp;
  List<Comment>? comments;
  List<String>? likes;
  Post({
    required this.id,
    required this.body,
    this.posterID,
    this.imgUrl,
    this.timestamp,
    this.likes,
    this.comments,
  });

  factory Post.fromMap(Map data) {
    return Post(
      id: data['id'] ?? '',
      body: data['body'] ?? '',
      posterID: data['posterID'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
      comments: data['comments'] != null
          ? List<Comment>.from(
              data['comments'].map((comment) => Comment.fromMap(comment)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'posterID': posterID,
      'imgUrl': imgUrl,
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments?.map((comment) => comment.toMap()).toList(),
    };
  }

  Post copyWith({
    String? id,
    String? body,
    String? posterID,
    String? imgUrl,
    DateTime? timestamp,
    List<String>? likes,
    List<Comment>? comments,
  }) {
    return Post(
      id: id ?? this.id,
      body: body ?? this.body,
      posterID: posterID ?? this.posterID,
      imgUrl: imgUrl ?? this.imgUrl,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'body': body,
        'posterID': posterID,
        'imgUrl': imgUrl,
        'timestamp': timestamp,
        'likes': likes,
        'comments': comments?.map((comment) => comment.toMap()).toList(),
      };

  // from json
  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        body: json['body'],
        posterID: json['posterID'],
        imgUrl: json['imgUrl'],
        timestamp: json['timestamp'],
        likes: json['likes'] != null
            ? List<String>.from(json['likes'].map((like) => like))
            : null,
        comments: json['comments'] != null
            ? List<Comment>.from(
                json['comments'].map((comment) => Comment.fromMap(comment)))
            : null,
      );
}

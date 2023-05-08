import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoctess_koneqt/models/comments_model.dart';

class NewsModel {
  static const ID = 'id';
  static const POSTER_ID = 'posterID';
  static const TITLE = 'title';
  static const BODY = 'body';
  static const IMG_URL = 'imgUrl';
  static const TIMESTAMP = 'timestamp';
  static const COMMENTS = 'comments';
  static const LIKES = 'likes';

  String? _id;
  String? _body;
  String? _title;
  String? _imgUrl;
  String? _posterID;
  DateTime? _timestamp;
  List<Comment>? _comments;
  int? _likes;

  String? get id => _id;

  String? get body => _body;

  String? get imgUrl => _imgUrl;
  String? get posterID => _posterID;

  DateTime? get timestamp => _timestamp;

  List<Comment>? get comments => _comments;
  int? get likes => _likes;
}

class News {
  String id;
  String body;
  String title;
  String? posterID;
  String? imgUrl;
  DateTime? timestamp;
  List<Comment>? comments;
  int likes = 0;
  News({
    required this.id,
    required this.title,
    required this.body,
    this.posterID,
    this.imgUrl,
    this.timestamp,
    this.likes = 0,
    this.comments,
  });

  factory News.fromMap(Map data) {
    return News(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
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
      title: title,
      'body': body,
      'posterID': posterID,
      'imgUrl': imgUrl,
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments?.map((comment) => comment.toMap()).toList(),
    };
  }

  News copyWith({
    String? id,
    String? title,
    String? body,
    String? posterID,
    String? imgUrl,
    DateTime? timestamp,
    int? likes,
    List<Comment>? comments,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
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
        title: title,
        'body': body,
        'posterID': posterID,
        'imgUrl': imgUrl,
        'timestamp': timestamp,
        'likes': likes,
        'comments': comments?.map((comment) => comment.toMap()).toList(),
      };

  // from json
  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        posterID: json['posterID'],
        imgUrl: json['imgUrl'],
        timestamp: (json['timestamp'] as Timestamp).toDate(),
        likes: json['likes'],
        comments: json['comments'] != null
            ? List<Comment>.from(
                json['comments'].map((comment) => Comment.fromMap(comment)))
            : null,
      );
}

import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  static const ID = 'id';
  static const POSTER_ID = 'posterID';
  static const TITLE = 'title';
  static const BODY = 'body';
  static const IMG_URL = 'imgUrl';
  static const TIMESTAMP = 'timestamp';
  static const VIEWS = 'views';
  static const LIKES = 'likes';

  String? _id;
  String? _body;
  String? _title;
  String? _imgUrl;
  String? _posterID;
  DateTime? _timestamp;
  List<String>? _views;

  String? get id => _id;
  String? get body => _body;
  String? get title => _title;
  String? get imgUrl => _imgUrl;
  String? get posterID => _posterID;
  DateTime? get timestamp => _timestamp;
  List<String>? get views => _views;
}

class News {
  String id;
  String body;
  String title;
  String? posterID;
  String? imgUrl;
  DateTime? timestamp;
  List<String>? views;

  News({
    required this.id,
    required this.title,
    required this.body,
    this.posterID,
    this.imgUrl,
    this.timestamp,
    this.views,
  });

  factory News.fromMap(Map data) {
    return News(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      posterID: data['posterID'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      views: data['views'] != null
          ? List<String>.from(data['views'].map((comment) => comment as String))
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
      'views': views?.map((comment) => comment).toList(),
    };
  }

  News copyWith({
    String? id,
    String? title,
    String? body,
    String? posterID,
    String? imgUrl,
    DateTime? timestamp,
    List<String>? views,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      posterID: posterID ?? this.posterID,
      imgUrl: imgUrl ?? this.imgUrl,
      timestamp: timestamp ?? this.timestamp,
      views: views ?? this.views,
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
        'views': views?.map((comment) => comment).toList(),
      };

  //get views count
  int get viewsCount => views?.length ?? 0;

  // from json
  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        posterID: json['posterID'],
        imgUrl: json['imgUrl'],
        timestamp: (json['timestamp'] as Timestamp).toDate(),
        views: json['views'] != null
            ? List<String>.from(
                json['views'].map((comment) => comment as String))
            : null,
      );
}

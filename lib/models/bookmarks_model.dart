const String bookmarkTable = 'bookmarks';

enum BookmarkType { post, news, event }

class Bookmark {
  final int? id;
  final String ref;
  final String title;
  final String data;
  final BookmarkType category;
  final String? createdAt;
  final String? updatedAt;

  Bookmark({
    this.id,
    required this.ref,
    required this.title,
    required this.data,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      ref: json['ref'],
      title: json['title'],
      data: json['data'],
      category: bookmarkTypeFromString(json['category']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ref': ref,
        'title': title,
        'data': data,
        'category': category,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Bookmark copyWith({
    int? id,
    String? ref,
    String? title,
    String? data,
    BookmarkType? category,
    String? createdAt,
    String? updatedAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      ref: ref ?? this.ref,
      title: title ?? this.title,
      data: data ?? this.data,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static BookmarkType bookmarkTypeFromString(String value) {
    switch (value) {
      case 'post':
        return BookmarkType.post;
      case 'news':
        return BookmarkType.news;
      case 'event':
        return BookmarkType.event;
      default:
        throw ArgumentError('Invalid BookmarkType value: $value');
    }
  }
}

class BookmarkModel {
  static const String id = "id";
  static const String ref = "ref";
  static const String title = "title";
  static const String data = "data";
  static const String category = "category";
  static const String createdAt = "createdAt";
  static const String updatedAt = "updatedAt";
}

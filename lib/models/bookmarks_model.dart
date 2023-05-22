const String bookmarkTable = 'bookmarks';

enum BookmarkType { post, news, event }

class BookmarkModel {
  final String ref;
  final String title;
  final String? image;
  final String? data;
  final BookmarkType category;
  final String createdAt;
  final String updatedAt;

  BookmarkModel({
    required this.ref,
    required this.title,
    required this.image,
    required this.data,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      ref: json['ref'],
      title: json['title'],
      image: json['image'],
      data: json['data'],
      category: json['category'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ref': ref,
        'title': title,
        'image': image,
        'data': data,
        'category': category,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  BookmarkModel copyWith({
    String? ref,
    String? title,
    String? image,
    String? data,
    BookmarkType? category,
    String? createdAt,
    String? updatedAt,
  }) {
    return BookmarkModel(
      ref: ref ?? this.ref,
      title: title ?? this.title,
      image: image ?? this.image,
      data: data ?? this.data,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

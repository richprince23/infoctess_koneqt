const String notesTable = 'notes';

class Note {
  final int? id;
  final String title;
  final String content;
  final String createdAt;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      NoteFields.id: id,
      NoteFields.title: title,
      NoteFields.content: content,
      NoteFields.createdAt: createdAt,
    };
  }

  static Note fromJson(Map<dynamic, Object?> json) {
    return Note(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String,
        content: json[NoteFields.content] as String,
        createdAt: json[NoteFields.createdAt] as String);
  }

  Note copy({var id, var title, var content, var createdAt}) {
    return Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt);
  }
}

class NoteFields {
  static const String id = 'id';
  static const String title = 'title';
  static const String content = 'content';
  static const String createdAt = 'created_at';
}

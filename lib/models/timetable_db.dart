const String schedulesTable = 'timetable';

class Timetable {
  int? id;
  String? courseCode;
  String? courseTitle;
  String? lecturer;
  String? venue;
  String? day;
  String? startTime;
  String? endTime;

  Timetable({
    this.id,
    this.courseCode,
    this.courseTitle,
    this.lecturer,
    this.venue,
    this.day,
    this.startTime,
    this.endTime,
  });

  Map<String, Object?> toJson() => {
        TimetableFields.id: id,
        TimetableFields.courseCode: courseCode,
        TimetableFields.courseTitle: courseTitle,
        TimetableFields.lecturer: lecturer,
        TimetableFields.venue: venue,
        TimetableFields.day: day,
        TimetableFields.startTime: startTime,
        TimetableFields.endTime: endTime,
      };

  static Timetable fromJson(Map<dynamic, Object?> json) {
    return Timetable(
      id: json[TimetableFields.id] as int,
      courseCode: json[TimetableFields.courseCode] as String?,
      courseTitle: json[TimetableFields.courseTitle] as String?,
      lecturer: json[TimetableFields.lecturer] as String?,
      day: json[TimetableFields.day] as String?,
      venue: json[TimetableFields.venue] as String?,
      startTime: json[TimetableFields.startTime] as String?,
      endTime: json[TimetableFields.endTime] as String?,
    );
  }

  Timetable copy({
    var id,
    var courseCode,
    var courseTitle,
    var lecturer,
    var venue,
    var day,
    var startTime,
    var endTime,
  }) {
    return Timetable(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      courseTitle: courseTitle ?? this.courseTitle,
      lecturer: lecturer ?? this.lecturer,
      venue: venue ?? this.venue,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class TimetableFields {
  static var id = 'id';
  static var courseCode = 'code';
  static var courseTitle = 'title';
  static var lecturer = 'lecturer';
  static var venue = 'venue';
  static var day = 'day';
  static var startTime = 'start_time';
  static var endTime = 'end_time';
}

final String coursesTable = 'courses';

class Course {
  var courseCode;
  var courseTitle;
  var creditHours;
  var id;
  var semester;
  var createdAt;
  var level;

  Course(
      {this.id,
      // this.uid,
      this.courseCode,
      this.courseTitle,
      this.level,
      this.semester,
      this.creditHours});

  Map<String, Object?> toJson() => {
        CourseFields.id: id,
        CourseFields.courseTitle: courseTitle,
        CourseFields.courseCode: courseCode,
        CourseFields.semester: semester,
        CourseFields.level: level,
        CourseFields.creditHours: creditHours,
        // CourseFields.createdAt: createdAt.toString(),
      };

  static Course fromJson(Map<dynamic, Object?> json) {
    return Course(
        id: json[CourseFields.id] as int?,
        courseCode: json[CourseFields.courseCode],
        courseTitle: json[CourseFields.courseTitle] as String?,
        semester: json[CourseFields.semester] as String?,
        level: json[CourseFields.level],
        creditHours: json[CourseFields.creditHours]);
  }

  Course copy(
      {var id,
      var courseCode,
      var courseTitle,
      dynamic creditHours,
      var semester,
      // var createdAt,
      var level}) {
    return Course(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      courseTitle: courseTitle ?? this.courseTitle,
      level: level ?? this.level,
      semester: semester ?? this.semester,
    );
  }
}

class CourseFields {
  static var courseCode = 'code';

  static String courseTitle = 'title';

  static var creditHours = 'hours';

  static var id = 'id';

  static String semester = "semester";

  // static final String createdAt = "created_at";

  static var level = "level";
}


// import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/models/bookmarks_model.dart';
import 'package:infoctess_koneqt/models/event_model.dart';
import 'package:infoctess_koneqt/models/timetable_db.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:infoctess_koneqt/models/courses_db.dart';
import 'package:infoctess_koneqt/models/notes_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB('test1.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = "STRING NOT NULL";
    const intType = "INTEGER NOT NULL";

    await db.execute('''
  CREATE TABLE $coursesTable(
    ${CourseFields.id} $idType, ${CourseFields.courseCode} $textType,
    ${CourseFields.courseTitle} $textType, ${CourseFields.semester} $textType,
    ${CourseFields.level} $textType, ${CourseFields.creditHours} $textType
  );
  
''');
    await db.execute('''CREATE TABLE $notesTable(
      ${NoteFields.id} $textType, ${NoteFields.title} $textType,
      ${NoteFields.content} $textType, ${NoteFields.createdAt} $textType
    )''');

    await db.execute('''CREATE TABLE $schedulesTable(
      ${TimetableFields.id} $idType, ${TimetableFields.courseCode} $textType,
      ${TimetableFields.courseTitle} $textType, ${TimetableFields.lecturer} $textType,
      ${TimetableFields.venue} $textType, ${TimetableFields.day} $textType,
      ${TimetableFields.startTime} $textType, ${TimetableFields.endTime} $textType
    )''');

    await db.execute(''' CREATE TABLE $eventsTable(
      ${EventModel.id} $idType, ${EventModel.title} $textType, ${EventModel.body} $textType, 
      ${EventModel.date} $textType, ${EventModel.time} $textType, ${EventModel.imgUrl} $textType, 
      ${EventModel.venue} $textType, ${EventModel.mode} $textType, ${EventModel.fee} $intType, 
      ${EventModel.timestamp} $textType
    )''');
  }

//courses operations
  Future<Course> addCourse(Course course) async {
    final db = await instance.database;

    final id = await db.insert(coursesTable, course.toJson());
    return course.copy(id: id);
  }

  Future<Course?> getCourse(int id) async {
    final db = await instance.database;

    final results = await db.query('courses',
        columns: [CourseFields.id.toString()],
        where: 'id = ?',
        whereArgs: [id]);
    if (results.isNotEmpty) {
      return Course.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<List<Course>> getCourses() async {
    final db = await instance.database;

    final results = await db.query(coursesTable);
    // inspect(results);
    return results.map((json) => Course.fromJson(json)).toList();
  }

  Future deleteCourse(int id) async {
    final db = await instance.database;
    return await db.delete("courses", where: 'id = ?', whereArgs: [id]);
  }

  //notes operations

  Future<Note> addNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert(notesTable, note.toJson());

    return note.copy(id: id);
  }

  Future<Note?> getNote(int id) async {
    final db = await instance.database;
    final res = await db.query("notes",
        columns: [NoteFields.id.toString()], where: 'id = ?', whereArgs: [id]);
    // if (res.isNotEmpty) {
    // inspect(res);
    return Note.fromJson(res.first);
    // }
  }

  Future<List<Note>> getNotes() async {
    final db = await instance.database;
    final res = await db.query('notes');
    return res.map((json) => Note.fromJson(json)).toList();
  }

  Future deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete("notes", where: 'id = ?', whereArgs: [id]);
  }

  //timetable operations
  Future<Timetable> addSchedule(Timetable subject) async {
    final db = await instance.database;

    final id = await db.insert(schedulesTable, subject.toJson());
    return subject.copy(id: id);
  }

  Future<List<Timetable>> getTodaySchedule(String day) async {
    final db = await instance.database;
    final res = await db.query("timetable",
        // columns: [TimetableFields.day.toString()],
        where: 'day = ?',
        whereArgs: [day]);
    return res.map((json) => Timetable.fromJson(json)).toList();
  }

  Future<List<Timetable>> getAllSchedules() async {
    final db = await instance.database;
    final res = await db.query('timetable');
    return res.map((json) => Timetable.fromJson(json)).toList();
  }

  Future deleteSchedule(int id) async {
    final db = await instance.database;
    return await db.delete("timetable", where: 'id = ?', whereArgs: [id]);
  }

//bookmark operations
  Future saveBookmark({
    required String ref,
    required String title,
    required BookmarkType category,
    required String data,
    String? imgUrl,
  }) async {
    final db = await instance.database;
    final id = await db.insert(bookmarkTable, {
      'ref': ref,
      'title': title,
      'image': imgUrl,
      'data': data,
      'category': category.toString(),
      'createdAt': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'updatedAt': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });
    return id;
  }

// get all bookmarks
  Future<List<BookmarkModel>> getAllBookmarks() async {
    final db = await instance.database;
    final res = await db.query(bookmarkTable);
    return res.map((json) => BookmarkModel.fromJson(json)).toList();
  }

// get bookmark by id
  Future<BookmarkModel?> getBookmark(String ref) async {
    final db = await instance.database;
    final res = await db.query(bookmarkTable,
        where: 'ref = ?', whereArgs: [ref], limit: 1);
    if (res.isNotEmpty) {
      return BookmarkModel.fromJson(res.first);
    } else {
      return null;
    }
  }

// delete bookmark
  Future deleteBookmark(String ref) async {
    final db = await instance.database;
    return await db.delete(bookmarkTable, where: 'ref = ?', whereArgs: [ref]);
  }

//close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

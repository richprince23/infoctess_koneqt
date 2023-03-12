// import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:infoctess_koneqt/models/courses_db.dart';
import 'package:infoctess_koneqt/models/notes_db.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB('portal3.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = "STRING NOT NULL";
    final intType = "INTEGER NOT NULL";

    await db.execute('''
  CREATE TABLE $coursesTable(
    ${CourseFields.id} $idType, ${CourseFields.courseCode} $textType,
    ${CourseFields.courseTitle} $textType, ${CourseFields.semester} $textType,
    ${CourseFields.level} $textType, ${CourseFields.creditHours} $textType
  );
  
''');
    await db.execute('''CREATE TABLE $notesTable(
      ${NoteFields.id} $idType, ${NoteFields.title} $textType,
      ${NoteFields.content} $textType, ${NoteFields.createdAt} $textType
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

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

import 'package:sqflite/sqflite.dart';

class DBHelper {
  void openDB() async {
    await openDatabase("my_portal");
  }
}

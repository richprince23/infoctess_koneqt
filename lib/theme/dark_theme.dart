import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const curTheme = "curTheme";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(curTheme, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(curTheme) ?? false;
  }
}
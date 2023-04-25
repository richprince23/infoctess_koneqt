import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      primaryColor: isDarkTheme ? Colors.black87 : Colors.white,
      primaryColorLight: isDarkTheme ? Colors.white : Colors.black87,
      primaryColorDark: isDarkTheme ? Colors.black87 : Colors.white,
      dialogBackgroundColor: isDarkTheme ? Colors.black45 : Colors.grey[100],
      backgroundColor: isDarkTheme
          ? const Color.fromRGBO(246, 7, 151, 1)
          : const Color.fromRGBO(74, 19, 193, 1),
      indicatorColor: isDarkTheme
          ? const Color.fromRGBO(74, 19, 193, 1)
          : const Color.fromRGBO(246, 7, 151, 1),
      hintColor:
          isDarkTheme ? const Color(0xff280C0B) : const Color(0xffEECED3),
      highlightColor: isDarkTheme
          ? const Color.fromRGBO(74, 19, 193, 0.3)
          : const Color.fromRGBO(246, 7, 151, 0.3),
      hoverColor:
          isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
      focusColor: isDarkTheme
          ? const Color.fromRGBO(74, 19, 193, 1)
          : const Color.fromRGBO(246, 7, 151, 1),
      disabledColor: Colors.grey,
      textTheme: TextTheme(
        button: GoogleFonts.sarabun(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      // textSelectionColor: isconst DarkTheme ? Colorsconst .white : Colors.black,
      cardColor: isDarkTheme ? const Color(0x001c1e26) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black54 : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(elevation: 0.0, color: Colors.white),
    );
  }
}

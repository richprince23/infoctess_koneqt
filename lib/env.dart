import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/screens/forums.dart';
import 'package:infoctess_koneqt/screens/home/homepage.dart';
import 'package:infoctess_koneqt/screens/onboarding.dart';
import 'package:infoctess_koneqt/screens/onboarding/acad_info.dart';
import 'package:infoctess_koneqt/screens/onboarding/basic_info.dart';
import 'package:infoctess_koneqt/screens/onboarding/profileinfo.dart';
import 'package:infoctess_koneqt/screens/tools/utilies_screen.dart';

extension Capitalized on String {
  String capitalized() =>
      this.substring(0, 1).toUpperCase() + this.substring(1).toLowerCase();
}

// onboarding screen
final PageController pageController = PageController(initialPage: 0);
var kPages = [
  BasicInfoScreen(
    key: Key("basic_info"),
  ),
  AcademicInfoScreen(
    key: Key("acad_info"),
  ),
  ProfileInfoScreen(
    key: Key("profile_info"),
  ),
];

var kMainPages = <Widget>[
  HomePage(),
  ForumsScreen(),
  UtilitiesScreen(),
];

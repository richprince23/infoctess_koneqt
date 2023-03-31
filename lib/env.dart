import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/models/user_info.dart';
import 'package:infoctess_koneqt/screens/forums.dart';
import 'package:infoctess_koneqt/screens/home/homepage.dart';
import 'package:infoctess_koneqt/screens/onboarding/acad_info.dart';
import 'package:infoctess_koneqt/screens/onboarding/basic_info.dart';
import 'package:infoctess_koneqt/screens/onboarding/profileinfo.dart';
import 'package:infoctess_koneqt/screens/tools/utilies_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// extension Capitalized on String {
//   String capitalized() =>
//       this.substring(0, 1).toUpperCase() + this.substring(1).toLowerCase();
// }

// onboarding screen
final PageController pageController = PageController(initialPage: 0);
var kPages = [
  const BasicInfoScreen(
    key: Key("basic_info"),
  ),
  AcademicInfoScreen(
    key: const Key("acad_info"),
  ),
  const ProfileInfoScreen(
    key: Key("profile_info"),
  ),
];

var kMainPages = <Widget>[
  const HomePage(),
  const ForumsScreen(),
  const UtilitiesScreen(),
];

final Future<SharedPreferences> mainPrefs = SharedPreferences.getInstance();

User? onboardUser;

User? curUser;
//form keys

final basicFormKey = GlobalKey<FormState>();
final acadFormKey = GlobalKey<FormState>();
final profileFormKey = GlobalKey<FormState>();

//onboarding controllers


String? avatarPath;

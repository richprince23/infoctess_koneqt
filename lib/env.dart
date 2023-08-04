// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/messages.dart';
import 'package:infoctess_koneqt/models/user_info.dart';
import 'package:infoctess_koneqt/screens/forums.dart';
import 'package:infoctess_koneqt/screens/home/homepage.dart';
import 'package:infoctess_koneqt/screens/onboarding/acad_info.dart';
import 'package:infoctess_koneqt/screens/onboarding/basic_info.dart';
import 'package:infoctess_koneqt/screens/onboarding/profileinfo.dart';
import 'package:infoctess_koneqt/screens/tools/utilies_screen.dart';
import 'package:infoctess_koneqt/screens/user_screens/user_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

// extension Capitalized on String {
//   String capitalized() =>
//       this.substring(0, 1).toUpperCase() + this.substring(1).toLowerCase();
// }
FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
RemoteConfigSettings configSettings = RemoteConfigSettings(
  fetchTimeout: const Duration(seconds: 30),
  minimumFetchInterval: const Duration(hours: 12),
);

User? curUser;
FirebaseAuth auth = FirebaseAuth.instance;

String? openAiKey = remoteConfig.getString("apiKeys");
// onboarding screen
final PageController pageController = PageController(initialPage: 0);
var kPages = [
  const BasicInfoScreen(
    key: Key("basic_info"),
  ),
  const AcademicInfoScreen(
    key: Key("acad_info"),
  ),
  const ProfileInfoScreen(
    key: Key("profile_info"),
  ),
];

var kMainPages = <Widget>[
  const HomePage(),
  const ForumsScreen(),
  const UtilitiesScreen(),
  ChatlistScreen(),
  const UserAccountScreen(),
];

final Future<SharedPreferences> mainPrefs = SharedPreferences.getInstance();

User? onboardUser;

//form keys

final basicFormKey = GlobalKey<FormState>();
final acadFormKey = GlobalKey<FormState>();
final profileFormKey = GlobalKey<FormState>();

//onboarding controllers

String? avatarPath;

final List<String> subjects = [
  'Data Structures and Algorithms',
  'Data Communications and Networking',
  'Intoduction to Programming with C++',
  'Object-Oriented Programming with Java',
  'Event-Driven Programming with VB.NET',
  'ASP.NET Webforms with C#',
  'Technology Project Management',
  'System Analysis and Design',
  'Multimedia Authoring',
  'Visual Literacy',
  'Technical Communication',
  'Emerging Technologies',
  'Educational',
  'General'
];

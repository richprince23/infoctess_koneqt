import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:infoctess_koneqt/screens/onboarding.dart';
import 'package:infoctess_koneqt/screens/post_page.dart';
import 'package:infoctess_koneqt/screens/tools/courses/add_course.dart';
import 'package:infoctess_koneqt/screens/tools/courses/courses.dart';
import 'package:infoctess_koneqt/screens/tools/gpa_calc/cgpa.dart';
import 'package:infoctess_koneqt/screens/tools/gpa_calc/gpa_calculator.dart';
import 'package:infoctess_koneqt/screens/tools/notes/add_note.dart';
import 'package:infoctess_koneqt/screens/tools/notes/my_notes.dart';
import 'package:infoctess_koneqt/screens/tools/schedules/add_schedule.dart';
import 'package:infoctess_koneqt/screens/tools/schedules/timetable.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => OnboardingController()),
      ChangeNotifierProvider(create: (_) => PageControl()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infoctess Koneqt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryTextTheme: GoogleFonts.sarabunTextTheme().apply(
          decoration: TextDecoration.none,
        ),
        textTheme: GoogleFonts.sarabunTextTheme().apply(
          decoration: TextDecoration.none,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        "/main": (context) => MainScreen(),
        "/onboarding": (context) => const OnboardingScreen(),
        "/post-details": (context) => PostDetails(),
        "/gpa-calculator": (context) => const GPAScreen(),
        "/cgpa-screen": (context) => const CGPAScreen(),
        "/my-courses": (context) => const ManageCourses(),
        "/add-course": (context) => const AddCoursePage(),
        "/my-notes": (context) => const MyNotes(),
        "/add-note": (context) => const AddNoteScreen(),
        "/my-schedules": (context) => const AllSchedules(),
        "/add-schedule": (context) => const AddScheduleScreen(),
      },
    );
  }
}

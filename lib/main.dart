import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/controllers/notification_service.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:infoctess_koneqt/screens/onboarding.dart';
import 'package:infoctess_koneqt/screens/onboarding/check_index.dart';
import 'package:infoctess_koneqt/screens/post_page.dart';
import 'package:infoctess_koneqt/screens/tools/courses/add_course.dart';
import 'package:infoctess_koneqt/screens/tools/courses/courses.dart';
import 'package:infoctess_koneqt/screens/tools/gpa_calc/cgpa.dart';
import 'package:infoctess_koneqt/screens/tools/gpa_calc/gpa_calculator.dart';
import 'package:infoctess_koneqt/screens/tools/notes/add_note.dart';
import 'package:infoctess_koneqt/screens/tools/notes/my_notes.dart';
import 'package:infoctess_koneqt/screens/tools/schedules/add_schedule.dart';
import 'package:infoctess_koneqt/screens/tools/schedules/timetable.dart';
import 'package:infoctess_koneqt/screens/tools/studymate/ai_imager.dart';
import 'package:infoctess_koneqt/screens/tools/studymate/aichat_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'package:resize/resize.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await dotenv.load();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => OnboardingController()),
      ChangeNotifierProvider(create: (_) => PageControl()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Resize(
      allowtextScaling: true,
      builder: () => MaterialApp(
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
        // initialRoute: initialRoute,
        initialRoute: "/login",
        routes: {
          '/login': (context) => const LoginScreen(),
          "/": (context) => MainScreen(),
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
          "/ai-studymate": (context) => const AIChatScreen(),
          "/ai-imager": (context) => const Imager(),
          "/checker" :(context) => const CheckAccessPage(),
        },
      ),
    );
  }
}



// FutureBuilder<bool>(
//         future: context.watch<UserProvider>().isLoggedIn,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // show loading indicator while waiting for future to complete
//             return CircularProgressIndicator(
//               color: AppTheme.themeData(false, context).backgroundColor,
//             );
//           } else {
//             // return the appropriate route based on the value of isLoggedIn
//             // final initialRoute = snapshot.data == true ? "/" : "/login";
//             return MaterialApp(
//               title: 'Infoctess Koneqt',
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData(
//                 useMaterial3: true,
//                 primaryTextTheme: GoogleFonts.sarabunTextTheme().apply(
//                   decoration: TextDecoration.none,
//                 ),
//                 textTheme: GoogleFonts.sarabunTextTheme().apply(
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//               // initialRoute: initialRoute,
//               initialRoute: "/",
//               routes: {
//                 '/login': (context) => const LoginScreen(),
//                 "/": (context) => MainScreen(),
//                 "/onboarding": (context) => const OnboardingScreen(),
//                 "/post-details": (context) => PostDetails(),
//                 "/gpa-calculator": (context) => const GPAScreen(),
//                 "/cgpa-screen": (context) => const CGPAScreen(),
//                 "/my-courses": (context) => const ManageCourses(),
//                 "/add-course": (context) => const AddCoursePage(),
//                 "/my-notes": (context) => const MyNotes(),
//                 "/add-note": (context) => const AddNoteScreen(),
//                 "/my-schedules": (context) => const AllSchedules(),
//                 "/add-schedule": (context) => const AddScheduleScreen(),
//                 "/ai-studymate": (context) => const AIChatScreen(),
//                 "/ai-imager": (context) => const Imager(),
//               },
//             );
//           }
//         },
//       ),
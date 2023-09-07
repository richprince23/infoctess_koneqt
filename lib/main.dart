import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/controllers/network_controller.dart';
import 'package:infoctess_koneqt/controllers/notification_service.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/controllers/post_controller.dart';
import 'package:infoctess_koneqt/controllers/profile_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/messages.dart';
import 'package:infoctess_koneqt/screens/admin/create_event.dart';
import 'package:infoctess_koneqt/screens/admin/manage_events.dart';
import 'package:infoctess_koneqt/screens/auth_gate.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:infoctess_koneqt/screens/misc/help_screen.dart';
import 'package:infoctess_koneqt/screens/misc/privacy.dart';
import 'package:infoctess_koneqt/screens/misc/terms.dart';
import 'package:infoctess_koneqt/screens/onboarding.dart';
import 'package:infoctess_koneqt/screens/onboarding/check_index.dart';
import 'package:infoctess_koneqt/screens/profile.dart';
import 'package:infoctess_koneqt/screens/start.dart';
import 'package:infoctess_koneqt/screens/tools/courses/add_course.dart';
import 'package:infoctess_koneqt/screens/tools/courses/courses.dart';
import 'package:infoctess_koneqt/screens/tools/dues/dues_main.dart';
import 'package:infoctess_koneqt/screens/tools/dues/new_payment.dart';
import 'package:infoctess_koneqt/screens/tools/gpa_calc/cgpa.dart';
import 'package:infoctess_koneqt/screens/tools/gpa_calc/gpa_calculator.dart';
import 'package:infoctess_koneqt/screens/tools/notes/add_note.dart';
import 'package:infoctess_koneqt/screens/tools/notes/my_notes.dart';
import 'package:infoctess_koneqt/screens/tools/schedules/add_schedule.dart';
import 'package:infoctess_koneqt/screens/tools/schedules/timetable.dart';
import 'package:infoctess_koneqt/screens/tools/studymate/ai_imager.dart';
import 'package:infoctess_koneqt/screens/tools/studymate/aichat_screen.dart';
import 'package:infoctess_koneqt/screens/tools/updates_screen.dart';
import 'package:infoctess_koneqt/screens/user_screens/bookmarks.dart';
import 'package:infoctess_koneqt/screens/user_screens/calendar.dart';
import 'package:infoctess_koneqt/screens/user_screens/chat_background.dart';
import 'package:infoctess_koneqt/screens/user_screens/edit_profile.dart';
import 'package:infoctess_koneqt/screens/user_screens/my_activity.dart';
import 'package:infoctess_koneqt/screens/user_screens/my_friends.dart';
import 'package:infoctess_koneqt/screens/user_screens/starred_messages.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await remoteConfig.setConfigSettings(configSettings);
  // await dotenv.load();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => OnboardingController()),
      ChangeNotifierProvider(create: (_) => PageControl()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => Stats()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => ChatProvider()),
      ChangeNotifierProvider(create: (_) => NetworkProvider()),
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
        home: const AuthGate(),

        routes: {
          '/start': (context) => const AuthGate(),
          '/login': (context) => const LoginScreen(),
          "/main": (context) => const MainScreen(),
          "/onboarding": (context) => const OnboardingScreen(),
          // "/post-details": (context) => PostDetails(),
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
          "/checker": (context) => const CheckAccessPage(),
          "/new-event": (context) => const CreateEvent(),
          "/calendar": (context) => const CalendarScreen(),
          "/bookmarks": (context) => const BookmarksScreen(),
          "/profile": (context) => const ProfileScreen(),
          "/chatlist": (context) => ChatlistScreen(),
          "/my-friends": (context) => const MyFriendsScreen(),
          "/my-activity": (context) => const MyActivityScreen(),
          "/chat-background": (context) => const ChatBackgroundScreen(),
          "/starred-messages": (context) => const StarredMessagesScreen(),
          "/edit-profile": (context) => const EditProfileScreen(),
          "/privacy-policy": (context) => const PrivacyPolicyScreen(),
          "/terms-and-conditions": (context) => const TermsConditionsScreen(),
          "/my-dues": (context) => const MyDuesScreen(),
          "/new-payment": (context) => const NewPayment(),
          "/check-updates": (context) => const UpdatesScreen(),
          "/help-support": (context) => const HelpSupportScreen(),
          "/manage-events": (context) => const ManageEventsScreen(),
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
        //   '/login': (context) => const LoginScreen(),
        //   "/": (context) => const MainScreen(),
        //   "/onboarding": (context) => const OnboardingScreen(),
        //   "/post-details": (context) => PostDetails(),
        //   "/gpa-calculator": (context) => const GPAScreen(),
        //   "/cgpa-screen": (context) => const CGPAScreen(),
        //   "/my-courses": (context) => const ManageCourses(),
        //   "/add-course": (context) => const AddCoursePage(),
        //   "/my-notes": (context) => const MyNotes(),
        //   "/add-note": (context) => const AddNoteScreen(),
        //   "/my-schedules": (context) => const AllSchedules(),
        //   "/add-schedule": (context) => const AddScheduleScreen(),
        //   "/ai-studymate": (context) => const AIChatScreen(),
        //   "/ai-imager": (context) => const Imager(),
        //   "/checker": (context) => const CheckAccessPage(),
        // },
//             );
//           }
//         },
//       ),
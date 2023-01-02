import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:infoctess_koneqt/screens/onboarding.dart';
import 'package:infoctess_koneqt/screens/post_page.dart';

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
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
        '/': (context) => LoginScreen(),
        "/main": (context) => MainScreen(),
        "/onboarding": (context) => OnboardingScreen(),
        "/post-details": (context) => PostDetails(),
      },
    );
  }
}

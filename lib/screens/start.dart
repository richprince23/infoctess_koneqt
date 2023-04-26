import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/screens/login_screen.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: context.watch<UserProvider>().isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // show loading indicator while waiting for future to complete
          return CircularProgressIndicator(
            color: cPri,
          );
        } else {
          final initialRoute = snapshot.data;
          if (initialRoute == true) {
            // void getOfflineUser() async {
            Provider.of<UserProvider>(context, listen: false).getUser;
            // }
            return const MainScreen();
          } else {
            return const LoginScreen();
          }
        }
      },
    );
  }
}

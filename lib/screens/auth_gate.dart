import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/screens/login_screen.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:resize/resize.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                "assets/images/preload.gif",
                height: 30.w,
                width: 30.w,
              ),
            );
          }
          if (snapshot.data != null && snapshot.data!.uid.isNotEmpty) {
            return const MainScreen();
          } else {
            auth.currentUser?.getIdTokenResult().then((value) {
              debugPrint("token ${value.token}");
            });
            return const LoginScreen();
          }
        });
  }
}

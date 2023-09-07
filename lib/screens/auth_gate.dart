import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/controllers/user_state.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/screens/login_screen.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isLoggedIn = false;
  User? user;
  StreamSubscription<User?>? userSub;

  // bool isInit = false;

  @override
  void initState() {
    super.initState();

    // Listen to auth token changes
    userSub = auth.idTokenChanges().listen((event) async {
      // print("token changed");
      await auth.currentUser?.getIdTokenResult().then((value) {
        // print("new token ${value.token}");
      });
    });

    userSub = auth.authStateChanges().listen((User? authUser) {
      if (authUser != null) {
        setState(() {
          isLoggedIn = true;
          user = authUser;
        });
        Future.delayed(const Duration(seconds: 2), () {
          getDetails();
        });
        // getDetails();
        // You can check the token expiration here and regenerate if needed.
        checkTokenExpiration(authUser);
      } else {
        auth.currentUser?.getIdTokenResult().then((value) {
          // print("token ${value.token}");
        });
        // setState(() {
        //   isLoggedIn = false;
        //   user = null;
        //   curUser = null;
        // });
      }
    });
  }

  Future getDetails() async {
    await Provider.of<UserState>(context, listen: false)
        .getUser(context)
        .then((value) => setState(() {
              curUser = value;
              // print("curUser: ${curUser?.toJson()}");
            }));
    // curUser = Provider.of<UserState>(context, listen: false).curUser;
  }

  // Check token expiration
  Future<void> checkTokenExpiration(User? user) async {
    if (user == null) return;

    final idTokenResult = await user.getIdTokenResult(true);
    final tokenExpirationTime = idTokenResult.expirationTime;

    final currentTime = DateTime.now();
    // Define a threshold for token expiration, e.g., 5 minutes before it expires
    final tokenThreshold = currentTime.add(const Duration(minutes: 5));

    if (tokenExpirationTime != null &&
        tokenExpirationTime.isBefore(tokenThreshold)) {
      // Token is about to expire, regenerate it
      await regenerateAuthTokens(user);
    }
  }

  // Regenerate token
  Future<void> regenerateAuthTokens(User user) async {
    await user.getIdToken();
    user.refreshToken;
    await getDetails();
    // print('Auth tokens regenerated successfully.');
  }

  @override
  void dispose() {
    super.dispose();
    userSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
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
        // Return mainscreen when userid is present and curUser is not null
        if (snapshot.data != null && snapshot.data!.uid.isNotEmpty) {
          // if (curUser == null) {
          //   return const OnboardingScreen();
          // }
          return const MainScreen();
        } else {
          auth.currentUser?.getIdTokenResult().then((value) {
            debugPrint("token ${value.token}");
          });
          return const LoginScreen();
        }
      },
    );
  }
}

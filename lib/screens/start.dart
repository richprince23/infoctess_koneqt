import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/screens/login_screen.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Future getOfflineUser(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).setUserDetails();
  }

  bool isLoggedIn = false;

  Future<void> checkLoginStatus() async {
    final userProvider = context.read<UserProvider>();

    bool? isLoggedIn;
    await userProvider.isLoggedIn.then((value) => isLoggedIn = value);
    print("check login: $isLoggedIn");

    if (isLoggedIn!) {
      await userProvider.getUserID();
      // User? curUser =
      await userProvider
          .getUserInfo()
          .then((value) async => {
                if (value == null)
                  {
                    await getOfflineUser(context),
                    await userProvider.getUserInfo(),
                  }
              })
          .then(
            (value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
            ),
          );
    } else {
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLoginStatus();
    });

    return Center(
      child: Image.asset(
        "assets/images/preload.gif",
        width: 50.w,
        height: 50.w,
      ),
    );
  }
}

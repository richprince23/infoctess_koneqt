import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/screens/login_screen.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Future getOfflineUser(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).setUserDetails();

    // print("user details set");
    // print(curUser!.toJson());
  }

  bool isLoggedIn = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    context
        .read<UserProvider>()
        .isLoggedIn
        .then((value) => isLoggedIn = value)
        .then((value) => print("check login:" "$isLoggedIn"))
        .then((value) => isLoggedIn ? getOfflineUser(context) : null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: context.watch<UserProvider>().isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // show loading indicator while waiting for future to complete
          return Center(
            child: CircularProgressIndicator(
              color: cPri,
            ),
          );
        }
        final initialRoute = snapshot.data;
        // print(initialRoute);
        if (initialRoute == true) {
          getOfflineUser(context);

          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

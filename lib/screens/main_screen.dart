// import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/appbar.dart';
import 'package:infoctess_koneqt/components/bottom_nav.dart';
import 'package:infoctess_koneqt/components/drawer.dart';
import 'package:infoctess_koneqt/controllers/network_controller.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/controllers/user_state.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ignore: unused_field
  // MyUser? _user;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // getOfflineUser();
    setAll();

    // initialize network listening stream
    connectivitySubscription =
        Provider.of<NetworkProvider>(context, listen: false)
            .connectivity
            .onConnectivityChanged
            .listen((ConnectivityResult result) {
      Provider.of<NetworkProvider>(context, listen: false)
          .updateConnectionStatus(result);
    });
  }

  void setAll() async {
    //set CurUser
    curUser = Provider.of<UserState>(context, listen: false).curUser;
    await Provider.of<NetworkProvider>(context, listen: false)
        .initConnectivity();
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(title: "Hi, ${curUser!.fullName?.split(" ")[0]}"),
      drawer: const DrawerScreen(),
      body: Consumer<PageControl>(
        builder: ((context, value, child) {
          return kMainPages[value.pageIndex];
        }),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/appbar.dart';
import 'package:infoctess_koneqt/components/bottom_nav.dart';
import 'package:infoctess_koneqt/components/drawer.dart';
import 'package:infoctess_koneqt/controllers/network_controller.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoggedIn = false;
  User? user;

  bool isInit = false;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // getOfflineUser();
    setAll();
    // getDetails();
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

  // void getDetails() async {
  //   await Provider.of<UserState>(context, listen: false)
  //       .getUser(context)
  //       .then((value) => setState(() {
  //             curUser = value;
  //             isInit =
  //                 Provider.of<UserState>(context, listen: false).isUserInit;
  //             print("curUser: ${curUser?.toJson()}");
  //             print(isInit);
  //           }));
  //   // curUser = Provider.of<UserState>(context, listen: false).curUser;
  // }

  void setAll() async {
    //set CurUser
    // curUser = Provider.of<UserState>(context, listen: false).curUser;
    // print("curUser: ${curUser?.toJson()}");
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
      appBar: AppBarScreen(title: "Hi, ${curUser?.fullName?.split(" ")[0]}"),
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

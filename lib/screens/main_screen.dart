// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/appbar.dart';
import 'package:infoctess_koneqt/components/bottom_nav.dart';
// import '../../components/drawer.dart';
import 'package:infoctess_koneqt/components/drawer.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:provider/provider.dart';

import '../models/user_info.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ignore: unused_field
  User? _user;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // getOfflineUser();
    setAll();
    // print("Printing from mainscreen init  ${_user?.emailAddress}");
  }

  // void getOfflineUser() async {
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Provider.of<UserProvider>(context, listen: false).setUserDetails();
  //   });
  // }
  void setAll() {
    //set CurUser
    Provider.of<UserProvider>(context, listen: false)
        .getUserInfo()
        .then((value) => setState(() {
              _user = value;
            }));

    // print("Printing from mainscreen set ALl 1  $curUser");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(),
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

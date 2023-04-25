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

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    getOfflineUser();
  }

  void getOfflineUser() async {
    Provider.of<UserProvider>(context, listen: false).getUser;
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

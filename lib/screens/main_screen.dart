import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/appbar.dart';
import 'package:infoctess_koneqt/components/bottom_nav.dart';
// import '../../components/drawer.dart';
import 'package:infoctess_koneqt/components/drawer.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBarScreen(),
      drawer: const DrawerScreen(),
      body: Consumer<PageControl>(
        builder: ((context, value, child) {
          return kMainPages[value.pageIndex];
        }),
      ),
      bottomNavigationBar: const BottomNav(),
    ));
  }
}

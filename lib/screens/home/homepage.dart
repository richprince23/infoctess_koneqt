import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/screens/home/announcements_screen.dart';
import 'package:infoctess_koneqt/screens/home/events_screen.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var tabs = [
    Tab(
      child: Text("News", style: TextStyle(fontSize: 14.sp)),
    ),
    Tab(
      child: Text("Events", style: TextStyle(fontSize: 14.sp)),
    )
  ];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cSec.withOpacity(0.1),
      body: Column(
        children: [
          TabBar(
            isScrollable: false,
            physics: const BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            indicatorColor: AppTheme.themeData(false, context).focusColor,
            controller: _tabController,
            tabs: tabs,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                NewsScreen(),
                EventsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

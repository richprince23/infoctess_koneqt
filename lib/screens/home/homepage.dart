import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/screens/home/announcements_screen.dart';
import 'package:infoctess_koneqt/screens/home/events_screen.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ScrollController _scrollController = ScrollController();
  var tabs = [
    const Tab(
      child: Text("News"),
    ),
    const Tab(
      child: Text("Events"),
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          collapsedHeight: 0,
          toolbarHeight: 0,
          floating: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: AppTheme.themeData(false, context).focusColor,
            controller: _tabController,
            tabs: tabs,
          ),
        ),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: TabBarView(
              controller: _tabController,
              children: [
                NewsScreen(),
                EventsScreen(),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

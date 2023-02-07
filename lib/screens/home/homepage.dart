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
  final ScrollController _scrollController = ScrollController();
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
          child: Container(
            decoration: const BoxDecoration(
              // color: Colors.blue,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black38, Colors.blue, Colors.pink],
                stops: [0.1, 0.2, 1],
              ),
            ),
            padding: const EdgeInsets.only(top: 50.0),
            child: TabBarView(
              controller: _tabController,
              children: const [
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

import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/screens/home/announcements_screen.dart';
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
    Tab(
      child: Text("News"),
    ),
    Tab(
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
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            child: TabBar(
              indicatorColor: AppTheme.themeData(false, context).focusColor,
              controller: _tabController,
              tabs: tabs,
            ),
          ),
        ),
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              NewsScreen(),
              Container(
                child: Center(child: Text("News")),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

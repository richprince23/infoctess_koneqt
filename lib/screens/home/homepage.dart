import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:infoctess_koneqt/components/new_post.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/screens/admin/create_news.dart';
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
  final _fabKey = GlobalKey<ExpandableFabState>();

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
            indicatorSize: TabBarIndicatorSize.tab,
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
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: (curUser != null || curUser?.isAdmin == true)
          ? ExpandableFab(
              type: ExpandableFabType.up,
              distance: 50.h,
              children: [
                FloatingActionButton(
                  backgroundColor: cSec,
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return const CreatePost();
                        });
                  },
                  child: Icon(
                    Icons.event,
                    size: 18.w,
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: cSec,
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              topRight: Radius.circular(10.r)),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return const CreateNews();
                        });
                  },
                  child: Icon(Icons.newspaper, size: 18.w, color: Colors.white),
                ),
              ],
            )
          : null,
    );
  }
}

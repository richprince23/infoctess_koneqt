import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/components/new_post.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/screens/admin/create_event.dart';
import 'package:infoctess_koneqt/screens/admin/create_news.dart';
import 'package:infoctess_koneqt/screens/home/announcements_screen.dart';
import 'package:infoctess_koneqt/screens/home/events_screen.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // final _fabKey = GlobalKey<ExpandableFabState>();

  late TabController _tabController;
  var tabs = [
    Tab(
      child: Text("Events", style: TextStyle(fontSize: 14.sp)),
    ),
    Tab(
      child: Text("News", style: TextStyle(fontSize: 14.sp)),
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

// TODO: implement search functionality and search history
  void _showModalSheet() {
    showBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        // isScrollControlled: true,
        context: context,
        builder: (context) {
          return Card(
            child: SizedBox(
              height: 40.vh,
              child: Center(
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text("search item $index"),
                    );
                  }),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cSec.withOpacity(0.05),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.h, vertical: 2.0.h),
            child: InputControl(
              hintText: "Search",
              showLabel: false,
              // onTap: _showModalSheet,
            ),
          ),
          TabBar(
            isScrollable: false,
            physics: const BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: cSec,
            controller: _tabController,
            tabs: tabs,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                EventsScreen(),
                NewsScreen(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Builder(
        builder: (context) =>
            Consumer<UserProvider>(builder: (context, value, child) {
          // print(curUser?.toJson());
          // if (curUser != null && curUser?.isAdmin == true) {
          if (curUser?.isAdmin == true) {
            return ExpandableFab(
              type: ExpandableFabType.up,
              distance: 50.h,
              children: [
                FloatingActionButton(
                  backgroundColor: cSec,
                  heroTag: "btn1",
                  onPressed: () {
                    Navigator.pushNamed(context, "/new-event");
                  },
                  child: Icon(
                    Icons.event,
                    size: 18.w,
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  backgroundColor: cSec,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateNews(),
                      ),
                    );
                  },
                  child: Icon(Icons.newspaper, size: 18.w, color: Colors.white),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        }),
      ),
    );
  }
}

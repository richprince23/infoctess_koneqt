import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/controllers/profile_controller.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/screens/convo_screen.dart';
import 'package:infoctess_koneqt/widgets/contact_item.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class MyFriendsScreen extends StatefulWidget {
  const MyFriendsScreen({super.key});

  @override
  State<MyFriendsScreen> createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  var tabs = ["Following", "Followers"];
  List following = [];
  List followers = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Friends'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              labelPadding: EdgeInsets.all(10.w),
              tabs: tabs.map((e) => Text(e)).toList(),
              controller: tabController,
              labelStyle: TextStyle(fontSize: 16.sp),
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: InputControl(
              // isSearch: true,
              hintText: "Search friends",
              showLabel: false,
              isCollapsed: true,
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                FutureBuilder(
                    future: Provider.of<ProfileProvider>(context, listen: false)
                        .getFollowingList()
                        .then((value) => following = value),
                    // initialData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return  Center(
                          child:    Image.asset(
                              "assets/images/preload.gif", width: 30.w, height: 30.w,
                            ),
                        );
                      }
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(
                          child: Text(
                            "Something went wrong",
                            style: TextStyle(
                              color: Colors.red[900],
                              fontSize: 18.sp,
                            ),
                          ),
                        );
                      }

                      if (following.isNotEmpty) {
                        return ListView.builder(
                          // controller: scrollController,
                          // itemCount: 10,
                          cacheExtent: 100.vh,
                          itemCount: following.length,
                          itemBuilder: (context, int index) {
                            return ListTile(
                              onTap: () async {
                                Poster sender = Poster();
                                await Provider.of<ProfileProvider>(context,
                                        listen: false)
                                    .getPosterDetails(
                                        userID: following[index], user: sender);
                                await startChat(memberID: following[index])
                                    .then((value) => {
                                          Navigator.pop(context),
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ConvoScreen(
                                                chatID: value,
                                                sender: sender,
                                              ),
                                            ),
                                          ),
                                        });
                              },
                              title: ContactItem(
                                userID: following[index],
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: EmptyList(
                          text:
                              "You don't have any followers yet\nFollow someone to see them here",
                        ),
                      );
                    }),

                //get followers list
                FutureBuilder(
                    future: Provider.of<ProfileProvider>(context, listen: false)
                        .getFollowersList()
                        .then((value) => followers = value),
                    // initialData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return  Center(
                          child:    Image.asset(
                              "assets/images/preload.gif", width: 30.w, height: 30.w,
                            ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Something went wrong",
                            style: TextStyle(
                              color: Colors.red[900],
                              fontSize: 18.sp,
                            ),
                          ),
                        );
                      }

                      if (followers.isNotEmpty) {
                        return ListView.builder(
                          // controller: scrollController,
                          // itemCount: 10,
                          cacheExtent: 100.vh,
                          itemCount: followers.length,
                          itemBuilder: (context, int index) {
                            return ListTile(
                              onTap: () async {
                                Poster sender = Poster();
                                await Provider.of<ProfileProvider>(context,
                                        listen: false)
                                    .getPosterDetails(
                                        userID: followers[index], user: sender);
                                await startChat(memberID: followers[index])
                                    .then((value) => {
                                          Navigator.pop(context),
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ConvoScreen(
                                                chatID: value,
                                                sender: sender,
                                              ),
                                            ),
                                          ),
                                        });
                              },
                              title: ContactItem(
                                userID: followers[index],
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: EmptyList(
                          text:
                              "You don't have any followers yet\nFollow someone to see them here",
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

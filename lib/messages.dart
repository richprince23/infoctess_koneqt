import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/widgets/contact_item.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:infoctess_koneqt/widgets/message_item.dart';
import 'package:resize/resize.dart';

class ChatlistScreen extends StatelessWidget {
  ChatlistScreen({super.key});
  List<Poster> followingList = [];
  List following = [];

  //get following list of current user

  Future<List> getFollowingList() async {
    // List<Poster> following = []; // Updated: Initialize as a List<Poster>
    await db
        .collection("user_infos")
        .where("userID", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) async {
      var user = value.docs[0];
      following.clear();
      for (var element in user.data()['following']) {
        // print(element);
        following.add(element);
      }
      // print(following.length);
    });

    return following;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(
              10.w,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              "Messages",
              style: TextStyle(
                fontSize: 18.sp + 1,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: db.collection("chats").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Something went wrong",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.sp,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: EmptyList(
                      text:
                          "You don't have any messages yet\nStart a conversation with someone to see them here",
                    ),
                  );
                }
                return ListView.builder(
                  cacheExtent: 100.vh,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ChatItem(
                      chatID: snapshot.data!.docs[index].id,
                      senderID: snapshot.data!.docs[index]['members'][0] ==
                              auth.currentUser!.uid
                          ? snapshot.data!.docs[index]['members'][1]
                          : snapshot.data!.docs[index]['members'][0],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: cSec,
          foregroundColor: Colors.white,
          elevation: 5,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        ),
        icon: const Icon(CupertinoIcons.plus_bubble),
        onPressed: () {
          showModalBottomSheet(
            enableDrag: true,
            isScrollControlled: true,
            // isDismissible: false,
            context: context,
            builder: (context) => buildContacts(context),
          );
        },
      ),
    );
  }

  //build userlist from following list
  Widget buildContacts(BuildContext context) {
    return Container(
      height: 90.vh,
      padding: EdgeInsets.symmetric(vertical: 10.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Followers",
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    // elevation: 0,
                    shape: const CircleBorder(),
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
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
            child: FutureBuilder(
                future: getFollowingList(),
                // initialData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
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

                  if (following.isNotEmpty) {
                    return ListView.builder(
                      // controller: scrollController,
                      // itemCount: 10,
                      itemCount: following.length,
                      itemBuilder: (context, int index) {
                        return ContactItem(
                          userID: following[index],
                        );
                      },
                    );
                  }
                  return Center(
                    child: EmptyList(
                      text:
                          "You don't have any friends yet\nFollow someone to see them here",
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

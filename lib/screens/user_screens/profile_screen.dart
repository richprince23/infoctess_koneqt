import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/controllers/profile_controller.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';
import 'package:infoctess_koneqt/screens/convo_screen.dart';
import 'package:infoctess_koneqt/screens/post_page.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class UserProfile extends StatefulWidget {
  final String userID;
  const UserProfile({Key? key, required this.userID}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  String followingStatus = "Follow";
  bool isChecking = false;
  final Poster user = Poster();
  final tabs = [
    Tab(
      child: Text("Shared Media", style: TextStyle(fontSize: 14.sp + 1)),
    ),
    Tab(
      child: Text("Posts", style: TextStyle(fontSize: 14.sp + 1)),
    ),
  ];

  //get poster details
  Future getPosterDetails({required userID}) async {
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: userID)
        .get()
        .then((value) {
      var details = value.docs[0].data();
      user.posterName = details['fullName'];
      user.posterID = details['userID'];
      user.userName = details['userName'];
      user.posterAvatarUrl = details['avatar'];
      user.isPosterAdmin = details['isAdmin'];
    });
    // Future.delayed(const Duration(seconds: 1));
    return userInfo;
  }

  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getUserSharedMedia(userID: widget.userID);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosterDetails(userID: widget.userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset(
              "assets/images/preload.gif",
              width: 30.w,
              height: 30.w,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 1,
            title: const Text("Profile Info"),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ImageViewer(image: user.posterAvatarUrl!);
                        }),
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 40.w,
                        backgroundImage: CachedNetworkImageProvider(
                          user.posterAvatarUrl ?? "",
                          errorListener: () => const Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.w),
                Text(
                  user.posterName ?? 'User Name',
                  style: TextStyle(fontSize: 20.sp + 1),
                  maxLines: 3,
                ),
                SizedBox(height: 5.w),
                Text("@${user.userName}"),
                SizedBox(height: 10.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        //check if user is a follower and enable follow button
                        try {
                          await followUser(userID: widget.userID).then(
                            (value) => setState(
                              () {
                                followingStatus = value;
                              },
                            ),
                          );
                        } catch (e) {
                          CustomDialog.show(
                            context,
                            title: "Error",
                            message: "An error occured. Please try again",
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.w,
                        ),
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: cPri,
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: isChecking == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text("$followingStatus"),
                    ),
                    SizedBox(width: 20.w),
                    //TODO: check if user is a follower and enable message button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FutureBuilder(
                                future: Future.wait([
                                  startChat(memberID: widget.userID),
                                ]),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Image.asset(
                                        "assets/images/preload.gif",
                                        width: 30.w,
                                        height: 30.w,
                                      ),
                                    );
                                  }
                                  return ConvoScreen(
                                    chatID: snapshot.data[0],
                                    sender: user,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.w),
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: cPri,
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: const Text("Message"),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
                TabBar(
                  tabs: tabs,
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                SizedBox(
                  height: 70.vh,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.w),
                        child: FutureBuilder(
                            future: getUserSharedMedia(userID: widget.userID),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Image.asset(
                                    "assets/images/preload.gif",
                                    width: 30.w,
                                    height: 30.w,
                                  ),
                                );
                              }
                              if (snapshot.data == null ||
                                  snapshot.data.length == 0 ||
                                  snapshot.hasError == true) {
                                return EmptyList(
                                  text:
                                      "${user.posterName} has not shared any media with you yet",
                                );
                              }
                              if (snapshot.hasData) {
                                return GridView.builder(
                                  itemCount: snapshot.data!.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5.w,
                                    mainAxisSpacing: 5.w,
                                  ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ImageViewer(
                                                image: snapshot.data![index],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data![index],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    );
                                  },
                                );
                              }
                              return EmptyList(
                                text:
                                    "${user.posterName} has not shared any media with you yet",
                              );
                            }),
                      ),
                      SizedBox(
                        height: double.maxFinite,
                        child: FutureBuilder(
                            future: getUserPosts(userID: widget.userID),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Image.asset(
                                    "assets/images/preload.gif",
                                    width: 30.w,
                                    height: 30.w,
                                  ),
                                );
                              }
                              if (snapshot.data == null ||
                                  snapshot.data.length == 0 ||
                                  snapshot.hasError == true) {
                                return EmptyList(
                                  text:
                                      "${user.posterName} has not shared any posts yet",
                                );
                              }
                              return ListView.builder(
                                itemCount: snapshot.data.length ?? 0,
                                itemBuilder: ((context, index) {
                                  final post = snapshot.data[index];
                                  Post postModel = Post(
                                    id: post.id,
                                    body: post['body'],
                                    timestamp: post['timestamp'].toDate(),
                                    posterID: post['posterID'],
                                    imgUrl: post['image'],
                                  );
                                  // Post postModel = Post.fromJson(post);
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return PostDetails(post: postModel);
                                          },
                                          settings: RouteSettings(
                                              name: '/post-details',
                                              arguments: user),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        user.posterAvatarUrl!,
                                        errorListener: () =>
                                            const Icon(Icons.person),
                                      ),
                                    ),
                                    title: Text(
                                      "${post['body']}",
                                      maxLines: 3,
                                    ),
                                    subtitle: Text(
                                      convertDateTimeString(
                                        (post['timestamp'] as Timestamp)
                                            .toDate()
                                            .toString(),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/controllers/network_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/screens/convo_screen.dart';
import 'package:infoctess_koneqt/widgets/contact_item.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:infoctess_koneqt/widgets/message_item.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';
import 'package:provider/provider.dart';

class ChatlistScreen extends StatefulWidget {
  const ChatlistScreen({Key? key}) : super(key: key);

  @override
  State<ChatlistScreen> createState() => _ChatlistScreenState();
}

class _ChatlistScreenState extends State<ChatlistScreen> {
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

  final Poster sender = Poster();

  //get poster details
  Future getPosterDetails({required userID}) async {
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: userID)
        .get()
        .then((value) {
      var details = value.docs[0].data();
      // if (mounted) {
      //   setState(() {
      sender.posterName = details['fullName'];
      sender.posterID = details['userID'];
      sender.userName = details['userName'];
      sender.posterAvatarUrl = details['avatar'];
      sender.isPosterAdmin = details['isAdmin'];
      // postComments = int.parse(getCommentsCount(widget.post.id).toString());
      // postLikes = int.parse(getLikesCount(widget.post.id).toString());
      // });
      // }
    });
    // }).then(
    //   (value) async => await getUnreadMessages(chatID: widget.chatID),
    // );
    return userInfo;
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      print("error");
      // return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus == ConnectivityResult.mobile ||
          _connectionStatus == ConnectivityResult.wifi) {
        Provider.of<NetworkProvider>(context, listen: false)
            .setConnection(true);
        print("connected");
      } else {
        Provider.of<NetworkProvider>(context, listen: false)
            .setConnection(false);
        print("not connected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NetworkProvider>(builder: (context, value, child) {
        return value.isConnected != true
            ? Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 50.w,
                        color: Colors.grey,
                      ),
                      Text(
                        "No internet connection",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Please check your internet connection",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: cSec,
                            ),
                          );
                        }
                        return ListView.builder(
                          cacheExtent: 100.vh,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              direction: Axis.horizontal,
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    autoClose: true,
                                    onPressed: (context) async {
                                      CustomDialog.showWithAction(context,
                                          message: "Delete Chat",
                                          action: () async {
                                        await db
                                            .collection("chats")
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete()
                                            .then(
                                              (value) => StatusAlert.show(
                                                context,
                                                duration:
                                                    const Duration(seconds: 2),
                                                title: 'Chat deleted',
                                                configuration:
                                                    const IconConfiguration(
                                                  icon: Icons.check,
                                                ),
                                              ),
                                            );
                                      });
                                    },
                                    label: 'Delete',
                                    backgroundColor: Colors.red,
                                    icon: Icons.delete,
                                  ),
                                ],
                              ),
                              child: ChatItem(
                                chatID: snapshot.data!.docs[index].id,
                                senderID: snapshot.data!.docs[index]['members']
                                            [0] ==
                                        auth.currentUser!.uid
                                    ? snapshot.data!.docs[index]['members'][1]
                                    : snapshot.data!.docs[index]['members'][0],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
      }),
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
                      cacheExtent: 100.vh,
                      itemCount: following.length,
                      itemBuilder: (context, int index) {
                        return ListTile(
                          onTap: () async {
                            getPosterDetails(userID: following[index]);
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

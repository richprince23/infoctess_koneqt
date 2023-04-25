import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:infoctess_koneqt/components/new_post.dart';
import 'package:infoctess_koneqt/components/post_item.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';
import 'package:resize/resize.dart';
import 'package:infoctess_koneqt/constants.dart';

class ForumsScreen extends StatefulWidget {
  const ForumsScreen({super.key});

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>> postsStream = FirebaseFirestore
      .instance
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: Container(
          color: cSec.withOpacity(0.1),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                postsStream = FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('timestamp', descending: true)
                    .snapshots();
              });
            },
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Image.asset(
                        "assets/images/preload.gif",
                        width: 50.h,
                        height: 50.h,
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return PostItem(
                          post: Post(
                            id: post.id,
                            body: post.data()['body'],
                            imgUrl: post.data()['image'],
                            posterID: post.data()['posterID'],
                            timestamp: post.data()['timestamp'].toDate(),
                          ),
                        );
                      });
                }),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: cSec,
          foregroundColor: Colors.white,
          elevation: 5,
        ),
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
                return const CreatePost();
              });
        },
        icon: Icon(Icons.add, size: 18.w),
        label: Text(
          "Create Post",
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }
}

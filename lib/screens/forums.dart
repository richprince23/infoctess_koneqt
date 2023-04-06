import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/new_post.dart';
import 'package:infoctess_koneqt/components/post_item.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';

class ForumsScreen extends StatefulWidget {
  const ForumsScreen({super.key});

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>> postsStream = FirebaseFirestore
      .instance
      .collection('posts')
      .orderBy('timestamp')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AnimatedContainer(
              // color: Colors.red,
              // padding: const EdgeInsets.all(5),
              duration: const Duration(milliseconds: 300),
              decoration: const BoxDecoration(
                // color: Colors.blue,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue, Colors.pink],
                  stops: [0.2, 1],
                ),
              ),
              child: const CreatePost(),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                // color: Colors.blue,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue, Colors.pink],
                  stops: [0.2, 1],
                ),
              ),
              height: double.infinity,
              // margin: const EdgeInsets.only(top: 40),
              // padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      postsStream = FirebaseFirestore.instance
                          .collection('posts')
                          .orderBy('timestamp')
                          .snapshots();
                    });
                  },
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: postsStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Image.asset(
                              "assets/images/preload.gif",
                              width: 50,
                              height: 50,
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
          )
        ],
      ),
    );
  }
}

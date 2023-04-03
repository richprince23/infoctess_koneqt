import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/new_post.dart';
import 'package:infoctess_koneqt/components/post_item.dart';

class ForumsScreen extends StatefulWidget {
  const ForumsScreen({super.key});

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
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
                    print("reloaded");
                  },
                  child: ListView(
                    children: const [
                      PostItem(),
                      PostItem(),
                      PostItem(),
                      PostItem(),
                      PostItem(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: ElevatedButton(
      //   child: Text("New Post"),
      //   onPressed: () {},
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

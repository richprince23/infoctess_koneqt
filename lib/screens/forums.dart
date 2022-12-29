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
                padding: const EdgeInsets.all(5),
                duration: const Duration(seconds: 1),
                child: CreatePost()),
          ),
          SliverFillRemaining(
            child: Container(
              height: double.infinity,
              // margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: RefreshIndicator(
                onRefresh: () async {
                  print("reloaded");
                },
                child: ListView(
                  children: [
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

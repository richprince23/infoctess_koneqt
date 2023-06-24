import 'package:infoctess_koneqt/components/post_item.dart';
import 'package:infoctess_koneqt/controllers/profile_controller.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';

class MyActivityScreen extends StatelessWidget {
  const MyActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Activity'),
        scrolledUnderElevation: 0.5,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: InputControl(
              isSearch: true,
              hintText: "Search posts, comments, etc",
              showLabel: false,
              isCollapsed: true,
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: Provider.of<ProfileProvider>(context).getUserPosts(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Image.asset(
                      "assets/images/preload.gif",
                      width: 30.w,
                      height: 30.w,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("An error occured "));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Post post = snapshot.data![index];
                      return PostItem(post: post);
                    },
                  );
                }
                return EmptyList(
                  text: "No activity yet",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

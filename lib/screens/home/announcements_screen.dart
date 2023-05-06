import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/news_item.dart';
import 'package:infoctess_koneqt/models/news_model.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: double.infinity,
      width: size.width,
      child: RefreshIndicator(
        onRefresh: () async => print("refreshed"),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('news')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Image.asset(
                    "assets/images/preload.gif",
                    width: 50.h,
                    height: 50.h,
                  ),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: EmptyList(
                    text:
                        "There isn't any News available \nKeeping checking here for updates",
                  ),
                );
              } else {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final newsData = snapshot.data!.docs[index];
                    print(newsData.data());
                    final newsInfo =
                        News.fromJson(newsData.data() as Map<String, dynamic>);
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0.h, vertical: 2.0.h),
                      child: NewsItem(
                        news: newsInfo,
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}

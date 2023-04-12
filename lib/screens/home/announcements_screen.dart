import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/news_item.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: size.width,
      // decoration: const BoxDecoration(
      //   // color: Colors.blue,
      //   gradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [Colors.blue, Colors.pink],
      //     stops: [0.2, 1],
      //   ),
      // ),
      child: RefreshIndicator(
        onRefresh: () async => print("refreshed"),
        child: ListView(
          children: const [
            NewsItem(),
            NewsItem(),
            NewsItem(),
            NewsItem(),
            NewsItem(),
            NewsItem(),
            NewsItem(),
            NewsItem(),
          ],
        ),
      ),
    );
  }
}

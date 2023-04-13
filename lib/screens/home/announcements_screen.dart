import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/news_item.dart';

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

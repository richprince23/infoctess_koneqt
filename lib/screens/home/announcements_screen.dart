import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/news_item.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: RefreshIndicator(
        onRefresh: () async => print("refreshed"),
        child: ListView(
          children: [
            NewsItem(),
            NewsItem(),
            NewsItem(),
          ],
        ),
      ),
    );
  }
}

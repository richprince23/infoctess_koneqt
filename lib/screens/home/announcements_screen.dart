import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/news_item.dart';
import 'package:infoctess_koneqt/components/post_item.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: ListView(
        children: [
          NewsItem(),
          NewsItem(),
          NewsItem(),
        ],
      ),
    );
  }
}

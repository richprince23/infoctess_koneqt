import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/post_item.dart';

class ForumsScreen extends StatefulWidget {
  const ForumsScreen({super.key});

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          PostItem(),
          PostItem(),
          PostItem(),
          PostItem(),
          PostItem(),
          PostItem(),
          PostItem(),
        ],
      ),
    );
  }
}

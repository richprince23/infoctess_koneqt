import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';

class StarredItem extends StatefulWidget {
  const StarredItem({super.key});

  @override
  State<StarredItem> createState() => _StarredItemState();
}

class _StarredItemState extends State<StarredItem> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("User name"),
        ChatBubble(
          hasOptions: false,
          isUser: false,
          message: "Hello this is a message",
          avatar: "https://picsum.photos/200/300",
          
        ),
      ],
    );
  }
}

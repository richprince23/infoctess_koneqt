import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  // final scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.25,
        maxChildSize: 0.25,
        minChildSize: 0.25,
        snap: false,
        builder: (context, scrollController) {
          return Container(
            color: Colors.green,
          );
        });
  }
}

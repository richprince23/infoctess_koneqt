import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/widgets/message_item.dart';
import 'package:resize/resize.dart';

class ChatlistScreen extends StatelessWidget {
  const ChatlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(
              10.w,
            ),
            child: Text(
              "Messages",
              style: TextStyle(
                fontSize: 18.sp + 1,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: null,
              builder: (context, snapshot) {
                return ListView.builder(
                  cacheExtent: 100.vh,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return ChatItem(
                      chatID: "as12ekj",
                      senderID: "8YPl5OCGyMZUwZZ8jpbpCtFquC03",
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: cSec,
          foregroundColor: Colors.white,
          elevation: 5,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        ),
        icon: const Icon(CupertinoIcons.plus_bubble),
        onPressed: () {},
      ),
    );
  }
}

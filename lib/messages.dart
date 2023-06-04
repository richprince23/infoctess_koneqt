import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
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
            alignment: Alignment.centerLeft,
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
              stream: db.collection("chats").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Something went wrong",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.sp,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: EmptyList(
                      text:
                          "You don't have any messages yet\nStart a conversation with someone to see them here",
                    ),
                  );
                }
                return ListView.builder(
                  cacheExtent: 100.vh,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ChatItem(
                      chatID: snapshot.data!.docs[index].id,
                      senderID: snapshot.data!.docs[index]['members'][0] ==
                              auth.currentUser!.uid
                          ? snapshot.data!.docs[index]['members'][1]
                          : snapshot.data!.docs[index]['members'][0],
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

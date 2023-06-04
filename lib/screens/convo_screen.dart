import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class ConvoScreen extends StatefulWidget {
  final Poster sender;
  final String chatID;

  const ConvoScreen({super.key, required this.sender, required this.chatID});

  @override
  State<ConvoScreen> createState() => _ConvoScreenState();
}

class _ConvoScreenState extends State<ConvoScreen> {
  final msgController = TextEditingController();
  @override
  void initState() {
    super.initState();
    markChatAsRead(chatID: widget.chatID);
  }

  @override
  void dispose() {
    super.dispose();
    msgController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        scrolledUnderElevation: 1,
        surfaceTintColor: cSec.withOpacity(0.1),
        title: Row(
          children: [
            CircleAvatar(
              radius: 15.r,
              backgroundImage: CachedNetworkImageProvider(
                widget.sender.posterAvatarUrl!,
                // "https://i.pravatar.cc/150?img=3",
                errorListener: () => const Icon(Icons.person),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sender.posterName ?? "User",
                  overflow: TextOverflow.ellipsis,
                ),
                Text("online", style: TextStyle(fontSize: 12.sp)),
              ],
            ),
          ],
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              child: StreamBuilder(
                stream: db
                    .collection("chats")
                    .doc(widget.chatID)
                    .collection("messages")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Something went wrong",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: EmptyList(
                        text:
                            "You don't have any messages yet\nStart a conversation with ${widget.sender.posterName} to see them here",
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(
                        message: snapshot.data!.docs[index]['message'],
                        isUser: snapshot.data!.docs[index]['senderID'] ==
                            auth.currentUser!.uid,
                        hasTime: true,
                        showAvatar: false,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            // height: 60,
            padding: EdgeInsets.all(5.w),
            child: Row(
              children: [
                Expanded(
                  child: InputControl(
                    showLabel: false,
                    hintText: "Type a message",
                    type: TextInputType.multiline,
                    controller: msgController,
                    isCollapsed: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

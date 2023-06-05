import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/screens/convo_screen.dart';
import 'package:resize/resize.dart';

class ChatItem extends StatefulWidget {
  final String senderID;
  final String chatID;

  const ChatItem({
    super.key,
    required this.senderID,
    required this.chatID,
  });

  @override
  State<ChatItem> createState() => ChatItemState();
}

class ChatItemState extends State<ChatItem> {
  final Poster sender = Poster();
  //get poster details
  Future getPosterDetails({required userID}) async {
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: userID)
        .get()
        .then((value) {
      var details = value.docs[0].data();
      if (mounted) {
        setState(() {
          sender.posterName = details['fullName'];
          sender.posterID = details['userID'];
          sender.userName = details['userName'];
          sender.posterAvatarUrl = details['avatar'];
          sender.isPosterAdmin = details['isAdmin'];
          // postComments = int.parse(getCommentsCount(widget.post.id).toString());
          // postLikes = int.parse(getLikesCount(widget.post.id).toString());
        });
      }
    });
    // }).then(
    //   (value) async => await getUnreadMessages(chatID: widget.chatID),
    // );
    return userInfo;
  }

  @override
  void initState() {
    super.initState();
    getLastMessage(chatID: widget.chatID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPosterDetails(userID: widget.senderID),
        builder: (context, snapshot) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ConvoScreen(sender: sender, chatID: widget.chatID),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10.w),
              margin: EdgeInsets.symmetric(vertical: 1.w, horizontal: 10.w),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.w),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: CachedNetworkImageProvider(
                      sender.posterAvatarUrl ??
                          "https://i.pravatar.cc/150?img=3",
                      errorListener: () =>
                          const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sender.posterName ?? "Loading...",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          lastMessage ?? "No message yet",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      unreadMessageList.isNotEmpty
                          ? Badge.count(
                              count: unreadMessageList.length,
                              backgroundColor: cSec,
                              textColor: Colors.white,
                              // textStyle: TextStyle(fontSize: 18.sp),
                              // largeSize: 30,
                              // padding: EdgeInsets.all(5.w),
                            )
                          : const SizedBox(
                              height: 3,
                            ),
                      SizedBox(
                        height: 5.w,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          convertToElapsedString(
                              lastMessageTime ?? DateTime.now().toString()),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
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
    return userInfo;
  }

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPosterDetails(userID: widget.senderID),
        builder: (context, snapshot) {
          print(sender.posterAvatarUrl);
          return InkWell(
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
                          const Icon(Icons.account_circle, color: Colors.grey),
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
                          sender.posterName ?? "Anonymous",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "Last Message",
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
                  Badge.count(
                    count: 10,
                    backgroundColor: cSec,
                    textColor: Colors.white,
                    // textStyle: TextStyle(fontSize: 18.sp),
                    // largeSize: 30,
                    // padding: EdgeInsets.all(5.w),
                  ),
                ],
              ),
            ),
          );
        });
    ;
  }
}

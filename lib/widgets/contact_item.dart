import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:resize/resize.dart';

class ContactItem extends StatefulWidget {
  final String userID;
  const ContactItem({super.key, required this.userID});

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  final Poster follower = Poster();

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
          follower.posterName = details['fullName'];
          follower.posterID = details['userID'];
          follower.userName = details['userName'];
          follower.posterAvatarUrl = details['avatar'];
          follower.isPosterAdmin = details['isAdmin'];
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
    // getPosterDetails(userID: widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosterDetails(userID: widget.userID),
      builder: (context, snapshot) {
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
                  radius: 15.r,
                  backgroundImage: CachedNetworkImageProvider(
                    follower.posterAvatarUrl ??
                        "https://i.pravatar.cc/150?img=3",
                    errorListener: () => const Icon(Icons.person),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  follower.posterName ?? "Loading...",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/models/comments_model.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/screens/user_screens/profile_screen.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  // final Poster user;
  CommentItem({
    Key? key,
    required this.comment,
    // required this.user
  }) : super(key: key);

  final Poster commenter = Poster();
  Future getPosterDetails({required Comment comment}) async {
    final userInfo = await FirebaseFirestore.instance
        .collection("user_infos")
        .where("userID", isEqualTo: comment.authorID)
        .get()
        .then((value) {
      var details = value.docs[0].data();
      // if (mounted) {
      //   setState(() {
      commenter.posterName = details['fullName'];
      commenter.posterID = details['userID'];
      commenter.userName = details['userName'];
      commenter.posterAvatarUrl = details['avatar'];
      commenter.isPosterAdmin = details['isAdmin'];
      // postComments = int.parse(getCommentsCount(widget.post.id).toString());
      // postLikes = int.parse(getLikesCount(widget.post.id).toString());
      //   });
      // }
    });
    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPosterDetails(comment: comment),
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.all(5.0.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                  child: CircleAvatar(
                    // radius: 25,
                    child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 120.w,
                        height: 120.w,
                        imageUrl: commenter.posterAvatarUrl ??
                            "https://i.pravatar.cc/150?img=3",
                        placeholder: (context, url) => Icon(
                          Icons.person,
                          // size: 120.w,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                          bottomLeft: const Radius.circular(0),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserProfile(userID: commenter.posterID!),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.w,
                            ),
                            // height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100.vw,
                                  child: Text(
                                    commenter.posterName ?? "Anonymous",
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                // Text(
                                //   "@${commenter.userName}",
                                //   style: GoogleFonts.sarabun(
                                //     fontWeight: FontWeight.w400,
                                //     fontSize: 12.sp,
                                //     color: Colors.black54,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetectableText(
                                detectionRegExp: detectionRegExp()!,
                                text: comment.text,
                                basicStyle: TextStyle(
                                  fontSize: 14.sp + 1,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                                moreStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp + 1,
                                  color: cPri,
                                ),
                                lessStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp + 1,
                                  color: cPri,
                                ),
                                onTap: (tappedText) async {
                                  if (tappedText.startsWith('#')) {
                                    // print('DetectableText >>>>>>> #');
                                  } else if (tappedText.startsWith('@')) {
                                    // print('DetectableText >>>>>>> @');
                                  } else if (tappedText.startsWith('http')) {
                                    // print('DetectableText >>>>>>> http');
                                    Uri url = Uri.parse(tappedText);
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      throw 'Could not launch $tappedText';
                                    }
                                  } else {
                                    // print("Post Details");
                                  }
                                },
                                // alwaysDetectTap: true,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  convertDateTimeString(
                                      comment.timestamp!.toString()),
                                  style: GoogleFonts.sarabun(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

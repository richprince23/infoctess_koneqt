import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/comment_input.dart';
import 'package:infoctess_koneqt/controllers/post_controller.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PostItem extends StatefulWidget {
  Post post;
  PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  int postLikes = 0;
  int postComments = 0;
  late Poster poster;

  String convertDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate =
        DateFormat('MMMM d, yyyy \'at\' h:mm a').format(dateTime);
    return formattedDate;
  }

  Future getPosterDetails() async {
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: widget.post.posterID.toString().trim())
        .get()
        .then((value) {
      var details = value.docs[0].data();

      setState(() {
        poster.posterName = details['fullName'];
        poster.posterID = details['userID'];
        poster.userName = details['userName'];
        poster.posterAvatarUrl = details['avatar'];
        poster.isPosterAdmin = details['isAdmin'];
        // postComments = int.parse(getCommentsCount(widget.post.id).toString());
        // postLikes = int.parse(getLikesCount(widget.post.id).toString());
      });
    });
    return userInfo;
  }

  Future<int> getCommentsCount(String docID) async {
    int totalDocuments = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(docID)
          .collection('comments')
          .get();
      totalDocuments = querySnapshot.size;
    } catch (e) {}
    return totalDocuments;
  }

  Future<int> getLikesCount(String docID) async {
    int totalLikes = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(docID)
          .collection('likes')
          .get();
      totalLikes = querySnapshot.size;
    } catch (e) {}
    return totalLikes;
  }

  @override
  void initState() {
    super.initState();
    poster = Poster();
    // getPosterDetails();
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosterDetails(),
      builder: (context, snapshot) {
        return InkWell(
          onTap: () async {
            await Navigator.pushNamed(context, '/post-details');
            print("Post Details");
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 1,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(5),
              elevation: 0.5,
              shadowColor: Colors.grey,
              color: AppTheme.themeData(false, context)
                  .primaryColor
                  .withOpacity(0.7),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      // height: 50,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CircleAvatar(
                              // radius: 25,
                              child: ClipOval(
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  width: 120,
                                  imageUrl: poster.posterAvatarUrl ??
                                      "https://picsum.photos/200",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                poster.posterName ?? "Anonymous",
                                style: GoogleFonts.sarabun(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                convertDateString(
                                    widget.post.timestamp.toString()),
                                style: GoogleFonts.sarabun(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // show post image
                    SizedBox(
                      child: widget.post.imgUrl != null
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 300,
                              imageUrl: widget.post.imgUrl!,
                            )
                          : const SizedBox.shrink(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          text: WidgetSpan(
                            child: DetectableText(
                              text: widget.post.body,
                              detectionRegExp: detectionRegExp(
                                  atSign: true, hashtag: true, url: true)!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              basicStyle: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppTheme.themeData(false, context)
                                      .primaryColorLight),
                              callback: (bool readMore) {
                                debugPrint('Read more >>>>>>> $readMore');
                              },
                              onTap: (tappedText) async {
                                if (tappedText.startsWith('#')) {
                                  print('DetectableText >>>>>>> #');
                                  //TODO: go to hashtag page
                                  //LATER : add hashtag page/feature
                                } else if (tappedText.startsWith('@')) {
                                  // TODO: go to user profile
                                  print('DetectableText >>>>>>> @');
                                } else if (tappedText.startsWith('http')) {
                                  // open url
                                  Uri url = Uri.parse(tappedText);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    throw 'Could not launch $tappedText';
                                  }
                                } else {
                                  await Navigator.pushNamed(
                                      context, '/post-details');
                                  print("Post Details");
                                }
                              },
                              alwaysDetectTap: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.post.likes} likes",
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.themeData(false, context)
                                  .primaryColorLight),
                        ),
                        Text(
                          "$postComments comments",
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.themeData(false, context)
                                  .primaryColorLight),
                        ),
                        Text(
                          "23 shares",
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.themeData(false, context)
                                  .primaryColorLight),
                        ),
                      ],
                    ),
                    Divider(
                      color: AppTheme.themeData(false, context).focusColor,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.heart,
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            size: 18,
                          ),
                          label: Text(
                            "like",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.themeData(false, context)
                                    .primaryColorLight),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showBottomSheet(
                                // barrierColor: Colors.transparent,
                                clipBehavior: Clip.antiAlias,
                                context: context,
                                builder: (context) => const CommentInput());
                          },
                          icon: Icon(
                            CupertinoIcons.chat_bubble,
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            size: 18,
                          ),
                          label: Text(
                            "comment",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.themeData(false, context)
                                  .primaryColorLight,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.share,
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            size: 18,
                          ),
                          label: Text(
                            "share",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.themeData(false, context)
                                  .primaryColorLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

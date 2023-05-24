import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/comment_input.dart';
import 'package:infoctess_koneqt/components/comment_item.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/post_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/bookmarks_model.dart';
import 'package:infoctess_koneqt/models/comments_model.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetails extends StatefulWidget {
  final Post post;
  const PostDetails({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  ScrollController listScroll = ScrollController();
  ScrollController pageScroll = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int viewsCount = 0;
  int likesCount = 0;
  bool isSaved = false;
  final controller = ScrollController();
  Poster? poster;
  //check if already bookmarked
  Future<bool> isBookmarked() async {
    final bookmarks = await AppDatabase.instance.getAllBookmarks();
    try {
      final bookmark = bookmarks.firstWhere(
        (element) => element.ref == widget.post.id,
        orElse: () => Bookmark(
            category: BookmarkType.event, data: "", ref: "", title: ""),
      );
      if (mounted) {
        if (bookmark.ref != "" && bookmark.id != null) {
          setState(() {
            isSaved = true;
          });
        } else {
          setState(() {
            isSaved = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return isSaved;
  }

  @override
  void initState() {
    // getPosterDetails();

    //count the view
    //check if already bookmarked
    isBookmarked();
    super.initState();
  }

  @override
  void dispose() {
    poster = null;
    listScroll.dispose();
    pageScroll.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    poster = ModalRoute.of(context)!.settings.arguments as Poster;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("${poster!.posterName?.split(" ")[0] ?? ''}'s Post"),
      ),
      body: SingleChildScrollView(
        controller: pageScroll,
        scrollDirection: Axis.vertical,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
            margin:
                EdgeInsets.only(top: 5.w, left: 5.w, right: 5.w, bottom: 10.w),
            child: Material(
              borderRadius: BorderRadius.circular(5.r),
              elevation: 0.5,
              shadowColor: Colors.grey,
              color: AppTheme.themeData(false, context).primaryColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      // height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
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
                                  imageUrl: poster?.posterAvatarUrl ??
                                      "https://i.pravatar.cc/150?img=3",
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
                                poster!.posterName!,
                                style: GoogleFonts.sarabun(
                                  fontSize: 16.sp + 1,
                                ),
                              ),
                              Text(
                                "December 12, 2022 8:56pm",
                                style: GoogleFonts.sarabun(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12.sp + 1,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: widget.post.imgUrl != null
                          ? CachedNetworkImage(
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: Image.asset(
                                  "assets/images/preload.gif",
                                  width: 30.w,
                                  height: 30.w,
                                ),
                              ),
                              fit: BoxFit.cover,
                              width: 100.vw,
                              imageUrl: widget.post.imgUrl!,
                            )
                          : const SizedBox.shrink(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: RichText(
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 5,
                        text: WidgetSpan(
                          child: DetectableText(
                            text: widget.post.body.trim(),
                            detectionRegExp: detectionRegExp()!,
                            // overflow: TextOverflow.ellipsis,
                            // maxLines: 3,
                            basicStyle: GoogleFonts.sarabun(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp + 1,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                            callback: (bool readMore) {
                              debugPrint('Read more >>>>>>> $readMore');
                            },
                            onTap: (tappedText) async {
                              if (tappedText.startsWith('#')) {
                                print('DetectableText >>>>>>> #');
                              } else if (tappedText.startsWith('@')) {
                                print('DetectableText >>>>>>> @');
                              } else if (tappedText.startsWith('http')) {
                                print('DetectableText >>>>>>> http');
                                Uri url = Uri.parse(tappedText);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw 'Could not launch $tappedText';
                                }
                              } else {
                                print("Post Details");
                              }
                            },
                            alwaysDetectTap: true,
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
                          "$likesCount likes",
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.themeData(false, context)
                                  .primaryColorLight),
                        ),
                        Text(
                          "77 comments",
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
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.r),
                                      topRight: Radius.circular(10.r)),
                                ),
                                isScrollControlled: true,
                                clipBehavior: Clip.antiAlias,
                                context: context,
                                builder: (context) => CommentInput(
                                      postID: widget.post.id,
                                    ));
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
          Container(
            height: 80.vh,
            color: cSec.withOpacity(0.1),
            // margin: EdgeInsets.only(top: 10.w),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .doc(widget.post.id)
                    .collection("comments")
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text("No comments yet"),
                    );
                  } else {
                    return ListView.builder(
                      controller: listScroll,
                      itemCount: snapshot.data!.docs.length ,
                      itemBuilder: ((context, index) {
                        Comment data =
                            Comment.fromJson(snapshot.data!.docs[index].data());
                        Comment comment = data.copyWith(
                          id: snapshot.data!.docs[index].id,
                        );
                        print(comment.toJson());
                        return CommentItem(
                          comment: comment,
                        );
                      }),
                    );
                  }
                }),
          ),
        ]),
      ),
    );
  }
}

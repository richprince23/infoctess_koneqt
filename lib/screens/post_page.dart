import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/components/comment_input.dart';
import 'package:infoctess_koneqt/components/comment_item.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/post_controller.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/models/bookmarks_model.dart';
import 'package:infoctess_koneqt/models/comments_model.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
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
  int commentsCount = 0;
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
    //check if already bookmarked
    isBookmarked();
    getStat();
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

  Future<int> getCommentsCount(String docID) async {
    int totalDocuments = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(docID)
          .collection('comments')
          .get();
      totalDocuments = querySnapshot.size;
      if (mounted) {
        setState(() {
          commentsCount = totalDocuments;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return totalDocuments;
  }

  Future<int> getLikesCount(String docID) async {
    int totalLikes = 0;
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection("posts").doc(docID).get();
      totalLikes = querySnapshot.data()!['likes'].length;
      if (mounted) {
        setState(() {
          likesCount = totalLikes;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return totalLikes;
  }

  Future getStat() async {
    await getCommentsCount(widget.post.id);
    await getLikesCount(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    poster = ModalRoute.of(context)!.settings.arguments as Poster;

    return KeyboardDismissOnTap(
      child: Scaffold(
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
                  EdgeInsets.only(top: 5.w, left: 5.w, right: 5.w, bottom: 0.w),
              child: Material(
                borderRadius: BorderRadius.circular(5.r),
                elevation: 0,
                shadowColor: Colors.grey,
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.w),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.w),
                        // height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                              child: CircleAvatar(
                                // radius: 25,
                                child: ClipOval(
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    width: 120.w,
                                    height: 120.w,
                                    imageUrl: poster?.posterAvatarUrl ??
                                        "https://i.pravatar.cc/150?img=3",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
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
                                  convertDateString(
                                    widget.post.timestamp!.toString(),
                                  ),
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
                        padding: EdgeInsets.only(top: 10.h),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            // overflow: TextOverflow.ellipsis,
                            // maxLines: 5,
                            text: WidgetSpan(
                              child: DetectableText(
                                text: widget.post.body.trim(),
                                detectionRegExp: detectionRegExp()!,
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 3,
                                textAlign: TextAlign.left,
                                basicStyle: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp + 1,
                                  color: Colors.black,
                                ),
                                lessStyle: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp + 1,
                                  color: cPri,
                                ),
                                moreStyle: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp + 1,
                                  color: cPri,
                                ),
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
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      FutureBuilder(
                          // future: getStat(),
                          builder: (context, snapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "$likesCount likes",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "$commentsCount comments",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
                            // Text(
                            //   "23 shares",
                            //   style: TextStyle(
                            //     fontSize: 12.sp,
                            //     color: Colors.black54,
                            //   ),
                            // ),
                          ],
                        );
                      }),
                      Divider(
                        color: cSec,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.heart,
                              color: Colors.black,
                              size: 18,
                            ),
                            label: Text(
                              "like",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),
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
                                ),
                              );
                            },
                            icon: const Icon(
                              CupertinoIcons.chat_bubble,
                              color: Colors.black87,
                              size: 18,
                            ),
                            label: Text(
                              "comment",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.share,
                              color: Colors.black87,
                              size: 18,
                            ),
                            label: Text(
                              "share",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
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
              height: 75.vh,
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
                      return Center(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              EmptyList(
                                text: "No comments yet",
                              ),
                              FilledButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: const Text("Add Comment"),
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
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        controller: listScroll,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          Comment data = Comment.fromJson(
                              snapshot.data!.docs[index].data());
                          Comment comment = data.copyWith(
                            id: snapshot.data!.docs[index].id,
                          );
                          // getPosterDetails(comment: comment);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CommentItem(
                              comment: comment,
                              // user: commenter,
                            ),
                          );
                        }),
                      );
                    }
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}

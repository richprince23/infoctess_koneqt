import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/post_controller.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';
import 'package:infoctess_koneqt/screens/post_page.dart';
import 'package:infoctess_koneqt/screens/user_screens/profile_screen.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/status_snack.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class PostItem extends StatefulWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  int postLikes = 0;
  int postComments = 0;
  late Poster poster;
  bool isLiked = false;

//get poster's details
  Future getPosterDetails() async {
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: widget.post.posterID.toString().trim())
        .get()
        .then((value) {
      var details = value.docs[0].data();
      if (mounted) {
        setState(() {
          poster.posterName = details['fullName'];
          poster.posterID = details['userID'];
          poster.userName = details['userName'];
          poster.posterAvatarUrl = details['avatar'];
          poster.isPosterAdmin = details['isAdmin'];
          // postComments = int.parse(getCommentsCount(widget.post.id).toString());
          // postLikes = int.parse(getLikesCount(widget.post.id).toString());
        });
      }
    });
    // await getStat();
    return userInfo;
  }

  //like post
  likePost(BuildContext context) async {
    await sendLike(widget.post.id)
        .then((value) => {isLiked = value as bool, getStat()})
        // .then((value) => setState(() {}))
        // .then((value) => isLiked = isLikedPost())
        .then(
          (value) => isLiked == true
              ? StatusAlert.show(
                  backgroundColor: Colors.transparent,
                  context,
                  configuration: IconConfiguration(
                    icon: Icons.favorite,
                    color: Colors.red,
                    size: 50.w,
                  ),
                  maxWidth: 50.vw,
                  duration: const Duration(seconds: 1),
                )
              : null,
        );
  }

  /// check if already liked
  bool isLikedPost() {
    // bool liked = false;
    Provider.of<Stats>(context, listen: false)
        .checkLike(widget.post.id)
        .then((value) => {
              // try {
              if (mounted)
                {
                  setState(() {
                    isLiked = value;
                  }),
                }
              // } catch (e) {
              //   CustomSnackBar.show(context, message: "An error occured");
              // }
            });
    return isLiked;
  }

  ///get all post stats
  Future getStat() async {
    // await getCommentsCount(widget.post.id);
    // await getLikesCount(widget.post.id);
    await Provider.of<Stats>(context, listen: false).getStats(widget.post.id);
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    poster = Poster();
    isLiked = isLikedPost();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPosterDetails();
      // getStat();
    });
    // getStat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget optionButton() {
    return PopupMenuButton<String>(
      tooltip: "Options",
      color: Colors.white.withOpacity(0.9),
      surfaceTintColor: cSec.withOpacity(0.03),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      onSelected: (String choice) {
        BuildContext ctx = context;
        // Handle menu item selection
        switch (choice) {
          case 'edit':
            // Do something
            debugPrint("Edit");
            break;
          case 'delete':
            // Do something
            CustomDialog.showWithAction(
              ctx,
              title: "Delete Post",
              message: "Are you sure you want to delete this post?",
              actionText: "Delete",
              action: () async {
                deletePost(widget.post.id).then(
                  (value) => CustomSnackBar.show(
                    ctx,
                    message: "Post deleted",
                  ),
                );
              },
            );

            break;
        }
      },
      itemBuilder: (BuildContext context) {
        // Define menu items
        return [
          PopupMenuItem<String>(
            value: 'edit',
            height: 30.w,
            enabled: false,
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  CupertinoIcons.pencil,
                  size: 18.w,
                  color: cPri,
                ),
                const SizedBox(width: 5),
                Text(
                  'Edit Post',
                  style: TextStyle(fontSize: 14.sp + 1),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            height: 30.w,
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  CupertinoIcons.delete,
                  size: 18.w,
                  color: Colors.red,
                ),
                const SizedBox(width: 5),
                Text(
                  'Delete Post',
                  style: TextStyle(fontSize: 14.sp + 1),
                ),
              ],
            ),
          ),
        ];
      },
      child: Icon(
        Icons.more_vert,
        size: 18.w,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosterDetails(),
      builder: (context, snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 1,
          ),
          padding: EdgeInsets.zero,
          child: Material(
            // borderRadius: BorderRadius.circular(8.r),
            elevation: 0,
            // shadowColor: Colors.grey,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 6.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            userID: widget.post.posterID!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      // height: 50,
                      margin: EdgeInsets.only(bottom: 5.w),
                      decoration: BoxDecoration(
                        color: cPri.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                            child: CircleAvatar(
                              // radius: 25,
                              foregroundImage: CachedNetworkImageProvider(
                                // fit: BoxFit.fill,
                                poster.posterAvatarUrl ??
                                    "https://i.pravatar.cc/150?img=3",
                                maxWidth: 120.w.toInt(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        poster.posterName ?? "Anonymous",
                                        style: GoogleFonts.sarabun(
                                          fontSize: 14.sp + 1,
                                          // color: Colors.black,
                                          // fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    poster.isPosterAdmin?.toString() == "true"
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 2.w),
                                            // decoration: BoxDecoration(
                                            //   color: cPri.withOpacity(0.1),
                                            //   borderRadius:
                                            //       BorderRadius.circular(10.r),
                                            // ),
                                            child: Icon(
                                              Icons.verified,
                                              size: 14.sp + 1,
                                              color: cSec,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                                Text(
                                  convertDateTimeString(
                                      widget.post.timestamp.toString()),
                                  style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp + 1,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),

                          // check if the current user is the post owner
                          poster.posterID == auth.currentUser?.uid
                              ? optionButton()
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  // show post image
                  InkWell(
                    onDoubleTap: () async {
                      await likePost(context);
                    },
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetails(
                            post: widget.post,
                          ),
                          settings: RouteSettings(
                              name: '/post-details', arguments: poster),
                        ),
                      );
                    },
                    child: Column(
                      children: [
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
                          padding: EdgeInsets.only(top: 10.w),
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
                                      fontSize: 16.sp + 1,
                                      color: Colors.black),
                                  callback: (bool readMore) {
                                    debugPrint('Read more >>>>>>> $readMore');
                                  },
                                  onTap: (tappedText) async {
                                    if (tappedText.startsWith('#')) {
                                      // debugPrint('DetectableText >>>>>>> #');
                                      // TOD: go to hashtag page
                                      //LATER : add hashtag page/feature
                                    } else if (tappedText.startsWith('@')) {
                                      // TOD: go to user profile
                                      // debugPrint('DetectableText >>>>>>> @');
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
                                      debugPrint("Post Details");
                                    }
                                  },
                                  // alwaysDetectTap: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Consumer<Stats>(
                        //       builder: (context, value, child) => Text(
                        //         "${value.likes} likes",
                        //         style: TextStyle(
                        //           fontSize: 12.sp + 1,
                        //           color: Colors.black54,
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 10.w,
                        //     ),
                        //     Consumer<Stats>(builder: (context, value, child) {
                        //       print(value.comments);
                        //       return Text(
                        //         "${value.comments} comments",
                        //         style: TextStyle(
                        //           fontSize: 12.sp + 1,
                        //           color: Colors.black54,
                        //         ),
                        //       );
                        //     }),
                        //     // Text(
                        //     //   "23 shares",
                        //     //   style: TextStyle(
                        //     //     fontSize: 12.sp + 1,
                        //     //     color: Colors.black54,
                        //     //   ),
                        //     // ),
                        //   ],
                        // ),

                        // Divider(
                        //   color: cSec,
                        //   thickness: 1,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     TextButton.icon(
                        //       onPressed: () async {
                        //         await likePost(context);
                        //       },
                        //       icon: Consumer<Stats>(
                        //         builder: (context, value, child) => Icon(
                        //           value.isLiked == false
                        //               ? Icons.favorite_outline
                        //               : Icons.favorite,
                        //           color: value.isLiked == false
                        //               ? Colors.black87
                        //               : Colors.red,
                        //           size: 18.w,
                        //         ),
                        //       ),
                        //       label: Text(
                        //         "like",
                        //         style: TextStyle(
                        //           fontSize: 14.sp + 1,
                        //           color: Colors.black87,
                        //         ),
                        //       ),
                        //     ),
                        //     TextButton.icon(
                        //       onPressed: () {
                        //         showModalBottomSheet(
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.only(
                        //                   topLeft: Radius.circular(10.r),
                        //                   topRight: Radius.circular(10.r)),
                        //             ),
                        //             isScrollControlled: true,
                        //             clipBehavior: Clip.antiAlias,
                        //             context: context,
                        //             builder: (context) => CommentInput(
                        //                   postID: widget.post.id,
                        //                 ));
                        //       },
                        //       icon: Icon(
                        //         CupertinoIcons.chat_bubble,
                        //         color: Colors.black87,
                        //         size: 18.w,
                        //       ),
                        //       label: Text(
                        //         "comment",
                        //         style: TextStyle(
                        //           fontSize: 14.sp + 1,
                        //           color: Colors.black87,
                        //         ),
                        //       ),
                        //     ),
                        //     TextButton.icon(
                        //       onPressed: () {},
                        //       icon: Icon(
                        //         Platform.isAndroid
                        //             ? CupertinoIcons.arrowshape_turn_up_right
                        //             : CupertinoIcons.share,
                        //         color: Colors.black87,
                        //         size: 18.w,
                        //       ),
                        //       label: Text(
                        //         "share",
                        //         style: TextStyle(
                        //           fontSize: 14.sp + 1,
                        //           color: Colors.black87,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Container(
                          width: 100.vw,
                          padding: EdgeInsets.symmetric(vertical: 10.w),
                          decoration: BoxDecoration(
                            // color: Colors.black12,
                            border:
                                Border.all(color: Colors.black12, width: 1.w),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            "View Post",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp + 1,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

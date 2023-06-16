import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/comment_input.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/post_controller.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';
import 'package:infoctess_koneqt/screens/post_page.dart';
import 'package:infoctess_koneqt/screens/user_screens/profile_screen.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
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

// check if already liked
  bool isLikedPost() {
    final _isLiked =
        Provider.of<Stats>(context, listen: false).checkLike(widget.post.id);
    try {
      if (mounted) {
        if (_isLiked == true) {
          setState(() {
            isLiked = true;
          });
        } else {
          setState(() {
            isLiked = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return isLiked;
  }

  //get all post stats
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

  Widget optionButton() {
    return PopupMenuButton<String>(
      tooltip: "Options",
      color: Colors.white,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      onSelected: (String choice) {
        // Handle menu item selection
        switch (choice) {
          case 'edit':
            // Do something
            debugPrint("Edit");
            break;
          case 'delete':
            // Do something
            debugPrint("Delete");
            CustomDialog.showWithAction(
              context,
              title: "Delete Post",
              message: "Are you sure you want to delete this post?",
              actionText: "Delete",
              action: () async {
                deletePost(widget.post.id).then(
                  (value) => StatusAlert.show(
                    context,
                    title: "Deleted",
                    titleOptions: StatusAlertTextConfiguration(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp + 1,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    maxWidth: 50.vw,
                    configuration: IconConfiguration(
                      icon: Icons.check,
                      color: Colors.green,
                      size: 50.w,
                    ),
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
            height: 30.h,
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Post',
                  style: TextStyle(fontSize: 14.sp + 1),
                ),
                Icon(
                  CupertinoIcons.pencil,
                  size: 18.w,
                  color: cPri,
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            height: 30.h,
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delete Post',
                  style: TextStyle(fontSize: 14.sp + 1),
                ),
                Icon(
                  CupertinoIcons.delete,
                  size: 18.w,
                  color: Colors.red,
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
          child: Material(
            borderRadius: BorderRadius.circular(8.r),
            elevation: 0,
            // shadowColor: Colors.grey,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 6.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      debugPrint("Go to user profle");
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
                      margin: EdgeInsets.only(bottom: 5.h),
                      decoration: BoxDecoration(
                        color: cPri.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0.h),
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
                                                horizontal: 5.w, vertical: 2.h),
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
                    enableFeedback: false,
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
                                      width: 30.h,
                                      height: 30.h,
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
                                      debugPrint('DetectableText >>>>>>> #');
                                      //TODO: go to hashtag page
                                      //LATER : add hashtag page/feature
                                    } else if (tappedText.startsWith('@')) {
                                      // TODO: go to user profile
                                      debugPrint('DetectableText >>>>>>> @');
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
                                  alwaysDetectTap: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
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
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

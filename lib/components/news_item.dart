import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/news_controller.dart' hide db;
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/news_model.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem extends StatefulWidget {
  // late Poster poster;
  final News news;
  NewsItem({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),

      tappable: true,
      transitionDuration: const Duration(milliseconds: 200),
      closedColor: Colors.white,
      // AppTheme.themeData(false, context).primaryColor.withOpacity(0.5),
      useRootNavigator: true,
      openElevation: 0,
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (BuildContext context, void Function() openAction) {
        return ClosedWidget(news: widget.news);
      },
      openBuilder: (BuildContext context, void Function() action) {
        return OpenWidget(
          news: widget.news,
        );
      },
    );
  }
}

class ClosedWidget extends StatefulWidget {
  final News news;
  const ClosedWidget({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  State<ClosedWidget> createState() => _ClosedWidgetState();
}

class _ClosedWidgetState extends State<ClosedWidget> {
  Poster? poster;

  // ignore: prefer_typing_uninitialized_variables

  @override
  void initState() {
    super.initState();
    poster = Poster();
    getPosterDetails();
  }

  Future getPosterDetails() async {
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: widget.news.posterID!.trim())
        .get()
        .then((value) {
      var details = value.docs[0].data();

      setState(() {
        poster?.posterName = details['fullName'];
        poster?.posterID = details['userID'];
        poster?.userName = details['userName'];
        poster?.posterAvatarUrl = details['avatar'];
        poster?.isPosterAdmin = details['isAdmin'];
        // postComments = int.parse(getCommentsCount(widget.post.id).toString());
        // postLikes = int.parse(getLikesCount(widget.post.id).toString());
      });
    });
    return userInfo;
  }

  Widget optionButton() {
    return PopupMenuButton<String>(
      iconSize: 24,
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
                deleteNews(widget.news.id).then(
                  (value) => StatusAlert.show(
                    context,
                    title: "Deleted",
                    titleOptions: StatusAlertTextConfiguration(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
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
                  'Edit News',
                  style: TextStyle(fontSize: 14.sp),
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
                  'Delete News',
                  style: TextStyle(fontSize: 14.sp),
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
    return Container(
      margin: EdgeInsets.all(12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100.w,
            height: 100.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: widget.news.imgUrl != null
                  ? CachedNetworkImage(
                      imageUrl: widget.news.imgUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      // child: Image.asset(
                      //   "assets/images/newspaper.png",
                      //   fit: BoxFit.cover,
                      // )
                      child: Icon(
                        Icons.newspaper,
                        color: Colors.grey[600],
                        size: 50.w,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "News",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: poster?.posterID == auth.currentUser?.uid
                          ? optionButton()
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
                Text(
                  widget.news.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color:
                          AppTheme.themeData(false, context).primaryColorLight),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  jsonDecode(widget.news.body)[0]['insert'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    overflow: TextOverflow.ellipsis,
                    color: AppTheme.themeData(false, context).primaryColorLight,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    convertDateString(widget.news.timestamp!.toString()),
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600]),
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

class OpenWidget extends StatefulWidget {
  final News news;
  OpenWidget({required this.news}) : super(key: UniqueKey());

  @override
  State<OpenWidget> createState() => _OpenWidgetState();
}

class _OpenWidgetState extends State<OpenWidget> {
  Poster? poster;
  // ignore: prefer_typing_uninitialized_variables
  late var myJSON;
  late QuillController _controller;

  Future getPosterDetails() async {
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: widget.news.posterID.toString().trim())
        .get()
        .then((value) {
      var details = value.docs[0].data();

      setState(() {
        poster?.posterName = details['fullName'];
        poster?.posterID = details['userID'];
        poster?.userName = details['userName'];
        poster?.posterAvatarUrl = details['avatar'];
        poster?.isPosterAdmin = details['isAdmin'];
        // postComments = int.parse(getCommentsCount(widget.post.id).toString());
        // postLikes = int.parse(getLikesCount(widget.post.id).toString());
      });
    });
    return userInfo;
  }

  @override
  void initState() {
    super.initState();
    poster = Poster();
    getPosterDetails();
    myJSON = jsonDecode(widget.news.body.toString());

    // _controller.document.insert(0, myJSON);
    _controller = QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0));
  }

  @override
  void dispose() {
    poster = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.news.imgUrl != null
              ? Stack(
                  children: [
                    Positioned(
                      child: widget.news.imgUrl != null
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ImageViewer(image: widget.news.imgUrl!),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: Colors.transparent,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.news.imgUrl!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 200.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: Image.asset(
                                      "assets/images/preload.gif",
                                      height: 20.h,
                                      width: 20.h,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    Positioned(
                      top: 48.h,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        // color: Colors.white,
                        // iconSize: ,
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  child: AppBar(
                    title: Text(
                      "News Details",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 24.h,
                    ),
                  ),
                ),
          Padding(
            padding:
                EdgeInsets.only(left: 16.0.w, right: 16.0.w, bottom: 8.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.news.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: AppTheme.themeData(false, context)
                            .primaryColorLight),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    maxLines: 8,
                  ),
                ),
                SizedBox(height: 10.h),
                // Divider(
                //   color: cSec,
                //   thickness: 1,
                // ),
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  width: double.infinity,
                  // child: RichText(
                  //   selectionColor: Colors.blueAccent,
                  //   textAlign: TextAlign.left,
                  //   overflow: TextOverflow.visible,
                  //   text: WidgetSpan(
                  //     child: DetectableText(
                  //       detectionRegExp: detectionRegExp()!,
                  //       text: jsonDecode(widget.news.body)[0]['insert']
                  //           .toString()
                  //           .trim(),
                  //       basicStyle: GoogleFonts.sarabun(
                  //           color: Colors.black, fontSize: 16.sp),
                  //       moreStyle: const TextStyle(
                  //         color: Colors.blue,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //       lessStyle: const TextStyle(
                  //         color: Colors.blue,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //       onTap: (tappedText) async {
                  //         if (tappedText.startsWith('#')) {
                  //           debugPrint('DetectableText >>>>>>> #');
                  //         } else if (tappedText.startsWith('@')) {
                  //           debugPrint('DetectableText >>>>>>> @');
                  //         } else if (tappedText.startsWith('http')) {
                  //           debugPrint('DetectableText >>>>>>> http');
                  //           // final link = await LinkPreviewer.getPreview(tappedText);
                  //           Uri url = Uri.parse(tappedText);
                  //           if (await canLaunchUrl(url)) {
                  //             await launchUrl(url);
                  //           } else {
                  //             throw 'Could not launch $tappedText';
                  //           }
                  //         } else {
                  //           debugPrint("nothing");
                  //         }
                  //       },
                  //     ),
                  //   ),
                  // ),

                  child: QuillEditor.basic(
                    controller: _controller,
                    readOnly: true,
                  ),
                ),
                SizedBox(height: 10.h),
                Card(
                  color: Colors.white.withOpacity(0.7),
                  elevation: 0,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.heart,
                                color: Colors.black87,
                                size: 18.w,
                              ),
                              label: Text(
                                "like",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: cSec, width: 1),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.chat_bubble,
                                color: Colors.black87,
                                size: 18.w,
                              ),
                              label: Text(
                                "comment",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: cSec, width: 1),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Platform.isAndroid
                                    ? CupertinoIcons.arrowshape_turn_up_right
                                    : CupertinoIcons.share,
                                color: Colors.black87,
                                size: 18.w,
                              ),
                              label: Text(
                                "share",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: cSec, width: 1),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "28 likes",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "23 comments",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "23 shares",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${poster?.posterName?.split(" ")[0]} ${poster?.posterName?.split(" ")[1][0]}.",
                      style: TextStyle(
                          fontSize: 13.sp, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      convertDateString(widget.news.timestamp!.toString()),
                      style: TextStyle(
                          fontSize: 13.sp, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

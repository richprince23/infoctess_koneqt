import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
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

class NewsItem extends StatefulWidget {
  // late Poster poster;
  final News news;
  const NewsItem({
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

  @override
  void dispose() {
    poster = null;
    super.dispose();
  }

  Future getPosterDetails() async {
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: widget.news.posterID!.trim())
        .get()
        .then((value) {
      var details = value.docs[0].data();
      if (mounted) {
        setState(() {
          poster?.posterName = details['fullName'];
          poster?.posterID = details['userID'];
          poster?.userName = details['userName'];
          poster?.posterAvatarUrl = details['avatar'];
          poster?.isPosterAdmin = details['isAdmin'];
          // postComments = int.parse(getCommentsCount(widget.post.id).toString());
          // postLikes = int.parse(getLikesCount(widget.post.id).toString());
        });
      }
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
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                      ),
                      progressIndicatorBuilder: (context, url, progress) =>
                          Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Image.asset(
                            "assets/images/preload.gif",
                            width: 20.w,
                            height: 20.w,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
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

      if (mounted) {
        setState(() {
          poster?.posterName = details['fullName'];
          poster?.posterID = details['userID'];
          poster?.userName = details['userName'];
          poster?.posterAvatarUrl = details['avatar'];
          poster?.isPosterAdmin = details['isAdmin'];
          // postComments = int.parse(getCommentsCount(widget.post.id).toString());
          // postLikes = int.parse(getLikesCount(widget.post.id).toString());
        });
      }
    });
    return userInfo;
  }

  @override
  void initState() {
    super.initState();
    poster = Poster();
    getPosterDetails();
    myJSON = jsonDecode(widget.news.body.toString());

    _controller = QuillController(
      document: Document.fromJson(myJSON),
      keepStyleOnNewLine: true,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    poster = null;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30.vh,
            child: Stack(
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
                                height: 30.vh,
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
                      : Container(
                          height: 30.vh,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/infoctess.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.news.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: AppTheme.themeData(false, context)
                              .primaryColorLight,
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.visible,
                        maxLines: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Expanded(
                  flex: 6,
                  child: Container(
                    // height: 100.vh,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      color: Colors.white,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    width: double.infinity,
                    child: QuillEditor(
                      // maxHeight: 80.vh,
                      //  minHeight: 30.vh,
                      textCapitalization: TextCapitalization.sentences,
                      scrollable: true,
                      expands: true,
                      autoFocus: false,
                      focusNode: FocusNode(),
                      padding: EdgeInsets.all(10.w),
                      scrollController: ScrollController(),
                      readOnly: true,
                      customStyles: DefaultStyles(
                        paragraph: DefaultTextBlockStyle(
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.sp,
                          ),
                          const VerticalSpacing(8, 0),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                      ),
                      controller: _controller,
                      // readOnly: true,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Card(
                //   color: Colors.white.withOpacity(0.7),
                //   elevation: 0,
                //   child: Padding(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                //     child: Column(
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             OutlinedButton.icon(
                //               onPressed: () {},
                //               icon: Icon(
                //                 CupertinoIcons.heart,
                //                 color: Colors.black87,
                //                 size: 18.w,
                //               ),
                //               label: Text(
                //                 "like",
                //                 style: TextStyle(
                //                   fontSize: 14.sp,
                //                   color: Colors.black87,
                //                 ),
                //               ),
                //               style: OutlinedButton.styleFrom(
                //                 side: BorderSide(color: cSec, width: 1),
                //               ),
                //             ),
                //             OutlinedButton.icon(
                //               onPressed: () {},
                //               icon: Icon(
                //                 CupertinoIcons.chat_bubble,
                //                 color: Colors.black87,
                //                 size: 18.w,
                //               ),
                //               label: Text(
                //                 "comment",
                //                 style: TextStyle(
                //                   fontSize: 14.sp,
                //                   color: Colors.black87,
                //                 ),
                //               ),
                //               style: OutlinedButton.styleFrom(
                //                 side: BorderSide(color: cSec, width: 1),
                //               ),
                //             ),
                //             OutlinedButton.icon(
                //               onPressed: () {},
                //               icon: Icon(
                //                 Platform.isAndroid
                //                     ? CupertinoIcons.arrowshape_turn_up_right
                //                     : CupertinoIcons.share,
                //                 color: Colors.black87,
                //                 size: 18.w,
                //               ),
                //               label: Text(
                //                 "share",
                //                 style: TextStyle(
                //                   fontSize: 14.sp,
                //                   color: Colors.black87,
                //                 ),
                //               ),
                //               style: OutlinedButton.styleFrom(
                //                 side: BorderSide(color: cSec, width: 1),
                //               ),
                //             ),
                //           ],
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               "28 likes",
                //               style: TextStyle(
                //                 fontSize: 12.sp,
                //                 color: Colors.black87,
                //               ),
                //             ),
                //             Text(
                //               "23 comments",
                //               style: TextStyle(
                //                 fontSize: 12.sp,
                //                 color: Colors.black87,
                //               ),
                //             ),
                //             Text(
                //               "23 shares",
                //               style: TextStyle(
                //                 fontSize: 12.sp,
                //                 color: Colors.black87,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
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
                            fontSize: 13.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
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

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
      closedElevation: 0,
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
                        color: Colors.black,
                        fontSize: 16.sp,
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
            height: 100.w,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "News",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                      ),
                      poster?.posterID == auth.currentUser?.uid
                          ? optionButton()
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                Text(
                  "${widget.news.title}\n",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color:
                          AppTheme.themeData(false, context).primaryColorLight),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   jsonDecode(widget.news.body)[0]['insert'],
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(
                //     fontWeight: FontWeight.w400,
                //     fontSize: 12.sp,
                //     overflow: TextOverflow.ellipsis,
                //     color: AppTheme.themeData(false, context).primaryColorLight,
                //   ),
                //   textAlign: TextAlign.left,
                // ),
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

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: 100.vw,
            height: 40.vh,
            child: CachedNetworkImage(
              imageUrl: widget.news.imgUrl ?? "",
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/infoctess.png",
                height: 30.vh,
                // width: 100.vw,
                fit: BoxFit.cover,
                // width: 30.h,
              ),
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: Image.asset(
                  "assets/images/preload.gif",
                  height: 30.h,
                  width: 30.h,
                ),
              ),
            ),
          ),
          Positioned(
            height: 40.vh,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 20.h),
            height: 120,
            child: Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    // elevation: 5,
                    padding: EdgeInsets.all(10.w),
                    backgroundColor: Colors.white.withOpacity(0.5),
                    // foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                IconButton(
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    // elevation: 5,
                    padding: EdgeInsets.all(10.w),
                    backgroundColor: Colors.white.withOpacity(0.5),
                    // foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                  // color: Colors.white,
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 63.vh / 100.vh,
            minChildSize: 63.vh / 100.vh,
            maxChildSize: 90.vh / 100.vh,
            controller: DraggableScrollableController(),
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: ListView(
                  // controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              height: 10.h,
                              width: 60.w,
                              child: Divider(
                                thickness: 5,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DecoratedBox(
                                decoration: const ShapeDecoration(
                                  shape: StadiumBorder(),
                                  color: Colors.black,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0.w,
                                    vertical: 5.h,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          poster?.posterAvatarUrl ??
                                              "https://picsum.photos/id/2/367/267",
                                          errorListener: () => const Icon(
                                            Icons.account_circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "${poster!.posterName?.split(" ")[0] ?? 'Anonymous'}  ${poster!.posterName?.split(" ")[1].substring(0, 1) ?? '.'}.",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DecoratedBox(
                                decoration: ShapeDecoration(
                                  shape: const StadiumBorder(),
                                  color: Colors.grey[300],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 15.sp,
                                        color: Colors.grey.shade800,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        convertToElapsedString(
                                            widget.news.timestamp!.toString()),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey.shade900,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DecoratedBox(
                                decoration: ShapeDecoration(
                                  shape: const StadiumBorder(),
                                  color: Colors.grey[300],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 15.sp,
                                        color: Colors.grey.shade800,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        widget.news.views?.length.toString() ??
                                            "0",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey.shade900,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.news.title,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 70.vh,
                            child: QuillEditor(
                              maxHeight: 20.vh,
                              textCapitalization: TextCapitalization.sentences,
                              scrollable: true,
                              expands: true,
                              autoFocus: false,
                              focusNode: FocusNode(),
                              padding: EdgeInsets.all(10.w),
                              scrollController: controller,
                              controller: _controller,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

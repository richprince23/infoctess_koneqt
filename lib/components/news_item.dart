import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/news_controller.dart' hide db;
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/bookmarks_model.dart';
import 'package:infoctess_koneqt/models/news_model.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:infoctess_koneqt/widgets/status_snack.dart';
import 'package:resize/resize.dart';

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
      color: Colors.white.withOpacity(0.9),
      surfaceTintColor: cSec.withOpacity(0.03),
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
            CustomDialog.showWithAction(
              context,
              title: "Delete Post",
              message: "Are you sure you want to delete this post?",
              actionText: "Delete",
              action: () async {
                deleteNews(widget.news.id).then(
                  (value) => CustomSnackBar.show(
                    context,
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
            enabled: false,
            value: 'edit',
            height: 30.w,
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
                  'Edit News',
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
                  'Delete News',
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
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 12.sp + 1),
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
                      fontSize: 16.sp + 1,
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
                //     fontSize: 12.sp + 1,
                //     overflow: TextOverflow.ellipsis,
                //     color: AppTheme.themeData(false, context).primaryColorLight,
                //   ),
                //   textAlign: TextAlign.left,
                // ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    convertDateTimeString(widget.news.timestamp!.toString()),
                    style: TextStyle(
                        fontSize: 13.sp + 1,
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
  int viewsCount = 0;
  bool isSaved = false;
  final controller = ScrollController();
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

  //check if already bookmarked
  Future<bool> isBookmarked() async {
    final bookmarks = await AppDatabase.instance.getAllBookmarks();
    try {
      final bookmark = bookmarks.firstWhere(
        (element) => element.ref == widget.news.id,
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
      // ignore: use_build_context_synchronously
      CustomSnackBar.show(context, message: "An error occurred");
    }
    return isSaved;
  }

  Future countView() async {
    List<dynamic>? views = <dynamic>[];
    final newsRef = db.collection("news").doc(widget.news.id);
    await newsRef.update({
      "views": FieldValue.arrayUnion([auth.currentUser?.uid])
    }).then((value) async => {
          newsRef.get().then((value) => {
                views = value.data()?["views"] as List<dynamic>?,
                if (mounted)
                  {
                    setState(() {
                      viewsCount = views!.length;
                    })
                  }
              })
        });
  }

  @override
  void initState() {
    super.initState();
    poster = Poster();
    getPosterDetails();
    myJSON = jsonDecode(widget.news.body.toString());
    //count the view
    countView();
    //check if already bookmarked
    isBookmarked();

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
                  height: 30.w,
                  width: 30.w,
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
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
                  icon: const BackButtonIcon(),
                ),
                const Spacer(),
                IconButton(
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    // elevation: 5,
                    padding: EdgeInsets.all(10.w),
                    backgroundColor: (isSaved == true)
                        ? cSec.withOpacity(1)
                        : Colors.white.withOpacity(0.5),
                    foregroundColor: (isSaved == true) ? Colors.white : null,
                  ),
                  onPressed: isSaved == true
                      ? () async {
                          await deleteBookmark(context);
                        }
                      : () async {
                          await addBookmark(context);
                        },
                  icon: const Icon(Icons.bookmark_border),
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
                              height: 1.w,
                              width: 50.w,
                              child: Divider(
                                thickness: 5,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.w),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DecoratedBox(
                                decoration: const ShapeDecoration(
                                  shape: StadiumBorder(),
                                  color: Colors.black,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 5.w,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          poster?.posterAvatarUrl ??
                                              "https://i.pravatar.cc/150?img=3",
                                          errorListener: () => const Icon(
                                              Icons.account_circle,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "${poster!.posterName?.split(" ")[0] ?? 'Anonymous'}  ${poster!.posterName?.split(" ")[1].substring(0, 1) ?? '.'}.",
                                        style: TextStyle(
                                          fontSize: 13.sp + 1,
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
                                        size: 15.sp + 1,
                                        color: Colors.grey.shade800,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        convertToElapsedString(
                                            widget.news.timestamp!.toString()),
                                        style: TextStyle(
                                          fontSize: 12.sp + 1,
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
                                        size: 15.sp + 1,
                                        color: Colors.grey.shade800,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        viewsCount.toString(),
                                        style: TextStyle(
                                          fontSize: 12.sp + 1,
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
                              fontSize: 20.sp + 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.w),
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
                              padding: EdgeInsets.symmetric(vertical: 10.w),
                              scrollController: controller,
                              controller: _controller,
                              readOnly: true,
                              customStyles: DefaultStyles(
                                paragraph: DefaultTextBlockStyle(
                                  TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.sp + 1,
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

  addBookmark(BuildContext context) async {
    await AppDatabase.instance
        .saveBookmark(
          ref: widget.news.id,
          title: widget.news.title,
          category: BookmarkType.news,
          data: widget.news.toJson().toString(),
        )
        .then((value) => CustomSnackBar.show(
              context,
              message: "Bookmark added",
            ))
        .then(
          (value) => setState(() {
            isSaved = !isSaved;
          }),
        );
  }

  Future deleteBookmark(BuildContext context) async {
    await AppDatabase.instance
        .deleteBookmark(
          widget.news.id,
        )
        .then(
          (value) => CustomSnackBar.show(
            context,
            message: "Bookmark removed",
          ),
        )
        .then(
          (value) => setState(() {
            isSaved = !isSaved;
          }),
        );
  }
}

class FindNewsItem extends StatefulWidget {
  final String newsID;
  const FindNewsItem({
    Key? key,
    required this.newsID,
  }) : super(key: key);

  @override
  State<FindNewsItem> createState() => _FindNewsItemState();
}

class _FindNewsItemState extends State<FindNewsItem> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.collection("news").doc(widget.newsID).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: EmptyList(
              text: "Error loading news",
            ),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(
            child: EmptyList(
              text: "News not found",
            ),
          );
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data();
          // print(data);
          // var news = News.fromJson(data);
          // News n = news.copyWith(id: snapshot.data!.id);
          // print(n.id);
          News news = News.fromMap(data);
          return OpenWidget(
              news: news.copyWith(
            id: snapshot.data!.id,
          ));
        }

        return Center(
          child: Image.asset(
            "assets/images/preload.gif",
            width: 30.w,
            height: 30.w,
          ),
        );
      },
    );
  }
}

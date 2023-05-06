import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/models/news_model.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem extends StatefulWidget {
  late Poster poster;
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

class ClosedWidget extends StatelessWidget {
  final News news;
  const ClosedWidget({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            news.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: AppTheme.themeData(false, context).primaryColorLight),
            textAlign: TextAlign.left,
          ),
          Divider(
            color: cSec,
            thickness: 1,
          ),
          Text(
            jsonDecode(news.body)[0]['insert'],
            maxLines: 2,
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
              "December 11, 2022, 11:34pm",
              style: TextStyle(fontSize: 13.sp, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class OpenWidget extends StatefulWidget {
  final News news;
  OpenWidget({super.key, required this.news});

  @override
  State<OpenWidget> createState() => _OpenWidgetState();
}

class _OpenWidgetState extends State<OpenWidget> {
  Poster? poster;

  Future getPosterDetails(News news) async {
    poster = Poster();
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: news.posterID.toString().trim())
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
    getPosterDetails(widget.news);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.news.title,
          style: TextStyle(fontSize: 14.sp),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          iconSize: 24.h,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 16.0.w, right: 16.0.w, bottom: 8.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.news.imgUrl != null
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
                  Text(
                    widget.news.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: AppTheme.themeData(false, context)
                            .primaryColorLight),
                    textAlign: TextAlign.left,
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
                    child: RichText(
                      selectionColor: Colors.blueAccent,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.visible,
                      text: WidgetSpan(
                        child: DetectableText(
                          detectionRegExp: detectionRegExp()!,
                          text: jsonDecode(widget.news.body)[0]['insert']
                              .toString()
                              .trim(),
                          basicStyle: GoogleFonts.sarabun(
                              color: Colors.black, fontSize: 16.sp),
                          moreStyle: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          lessStyle: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          onTap: (tappedText) async {
                            if (tappedText.startsWith('#')) {
                              debugPrint('DetectableText >>>>>>> #');
                            } else if (tappedText.startsWith('@')) {
                              debugPrint('DetectableText >>>>>>> @');
                            } else if (tappedText.startsWith('http')) {
                              debugPrint('DetectableText >>>>>>> http');
                              // final link = await LinkPreviewer.getPreview(tappedText);
                              Uri url = Uri.parse(tappedText);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $tappedText';
                              }
                            } else {
                              debugPrint("nothing");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: cSec,
                    thickness: 1,
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
                        "December 11, 2022, 11:34pm",
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
      ),
    );
  }
}

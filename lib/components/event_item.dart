import 'dart:io';

import 'package:animations/animations.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher.dart';

class EventItem extends StatefulWidget {
  const EventItem({super.key});

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: OpenContainer(
        closedColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        closedBuilder: (context, action) => const ClosedEventItem(),
        openBuilder: (context, action) => const OpenEventItem(),
      ),
    );
  }
}

class ClosedEventItem extends StatelessWidget {
  const ClosedEventItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.w),
      child: Card(
        color: AppTheme.themeData(false, context).primaryColor.withOpacity(0.7),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
        ),
        surfaceTintColor: Colors.white,
        child: Container(
          margin: EdgeInsets.all(8.w),
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Infoctess General Meeting",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color:
                        AppTheme.themeData(false, context).primaryColorLight),
                textAlign: TextAlign.left,
              ),
              RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                text: TextSpan(
                  text:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed eu",
                  style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color:
                          AppTheme.themeData(false, context).primaryColorLight),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "President",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  Text(
                    "December 11, 2022, 11:34pm",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OpenEventItem extends StatelessWidget {
  const OpenEventItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Details",
          style: TextStyle(fontSize: 14.sp),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          iconSize: 24.h,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => Platform.isIOS
                ? showIosActionSheet(context)
                : showAndroidActionSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 60.h),
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImageViewer(
                      image: "assets/images/img1.jpg",
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.red,
                  ),
                  child: Image.asset(
                    "assets/images/img1.jpg",
                    height: 200.h,
                    width: 100.vw,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                "Infoctess General Meeting",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color:
                        AppTheme.themeData(false, context).primaryColorLight),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10.h),
              Divider(
                color: AppTheme.themeData(false, context).focusColor,
                thickness: 1,
              ),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  color: Colors.white38.withOpacity(0.7),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Fee: ",
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "GH₵ 10.00",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Date: ",
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "December 11, 2022, 11:34pm",
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Venue: ",
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "1234 Main Street, New York, NY 10001 sdfhjksdhfj kshdjfhsjkdhf jsdhfjksdhfjk",
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.left,
                overflow: TextOverflow.visible,
                text: WidgetSpan(
                  child: DetectableText(
                    detectionRegExp: detectionRegExp()!,
                    text:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed eu",
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
                        print('DetectableText >>>>>>> #');
                      } else if (tappedText.startsWith('@')) {
                        print('DetectableText >>>>>>> @');
                      } else if (tappedText.startsWith('http')) {
                        print('DetectableText >>>>>>> http');
                        // final link = await LinkPreviewer.getPreview(tappedText);
                        Uri url = Uri.parse(tappedText);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $tappedText';
                        }
                      } else {
                        print("nothing");
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Divider(
                  color: AppTheme.themeData(false, context).focusColor,
                  thickness: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "President",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  Text(
                    "December 11, 2022, 11:34pm",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showIosActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: ((context) => CupertinoActionSheet(
            title: const Text("Actions"),
            // message: const Text("This is a message"),
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  "RSVP",
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  "Remind Me",
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )),
    );
  }

  void showAndroidActionSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 170.0.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  "Actions",
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
                        icon: Icon(Icons.alarm, size: 20.w),
                        onPressed: () {
                          //TODO: Add notification functionality
                          Navigator.pop(context);
                        },
                        label: const Text("Notify"),
                        style: OutlinedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 12.sp),
                          backgroundColor: cPri,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          fixedSize: Size(100.vw, 50.h),
                        ),
                      ),
                      OutlinedButton.icon(
                        icon: Icon(Icons.checklist, size: 20.w),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: const Text("RSVP"),
                        style: OutlinedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 12.sp),
                          backgroundColor: cPri,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          fixedSize: Size(100.vw, 50.h),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

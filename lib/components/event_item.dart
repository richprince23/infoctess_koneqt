import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:resize/resize.dart';

class EventItem extends StatefulWidget {
  const EventItem({super.key});

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      tappable: true,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      transitionDuration: const Duration(milliseconds: 200),
      closedColor: Colors.white,
      // AppTheme.themeData(false, context).primaryColor.withOpacity(0.5),
      useRootNavigator: true,
      openElevation: 0,
      closedElevation: 0,
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (context, action) => const ClosedEventItem(),
      openBuilder: (context, action) => OpenEventItem(),
    );
  }
}

class ClosedEventItem extends StatelessWidget {
  const ClosedEventItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.vh,
      margin: EdgeInsets.all(12.w),
      // padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: "https://picsum.photos/250?image=5",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.grey[300],
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.grey[300],
                    ),
                  ),
                ),

                //Decorated Box
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8.r),
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [
                //         Colors.transparent,
                //         Colors.black.withOpacity(0.7),
                //       ],
                //     ),
                //   ),
                // ),
                Positioned(
                  top: 0,
                  right: 0,
                  // width: 100,
                  // height: 60,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "MAY 19",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100.vw,
            padding: EdgeInsets.all(10.w),
            color: Colors.white,
            child: Text(
              "Infoctess Akwaaba",
              style: GoogleFonts.sarabun(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class OpenEventItem extends StatefulWidget {
  OpenEventItem({super.key});

  @override
  State<OpenEventItem> createState() => _OpenEventItemState();
}

class _OpenEventItemState extends State<OpenEventItem> {
  late QuillController _controller;
  final scroller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        controller: scroller,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                // padding: EdgeInsets.all(10.w),
                height: 30.vh,
                width: 100.vw,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageViewer(
                          image: "https://picsum.photos/250?image=5",
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: "https://picsum.photos/250?image=5",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.grey[300],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Infoctess Akwaaba",
                style: GoogleFonts.sarabun(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10.h),
              Text(
                "Posted by Somebody",
                style: GoogleFonts.sarabun(
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 100.w),
                width: 100.vw,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: cSec.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0.w),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "May".substring(0, 3),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "19",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50.h,
                      width: 0.5.w,
                      color: cPri,
                      margin: EdgeInsets.symmetric(horizontal: 10.h),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "Friday",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "8:00 am - 5:00 pm",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: cPri,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        onPressed: () {},
                        child: Column(
                          children: [
                            const Icon(Icons.calendar_month),
                            Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              const Text("Event Details"),
              SizedBox(height: 10.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 70.vh,
                child: QuillEditor(
                  // maxHeight: 100.vh,
                  textCapitalization: TextCapitalization.sentences,
                  scrollable: true,
                  expands: true,
                  autoFocus: false,
                  focusNode: FocusNode(),
                  padding: EdgeInsets.all(10.w),
                  scrollController: scroller,
                  controller: _controller,
                  readOnly: true,
                  placeholder:
                      "lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet orem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet orem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet orem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet orem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet orem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet orem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet orem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet orem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet",
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
          height: 180.0.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    // mainAxisSize: MainAxisSize.min,
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
                      SizedBox(
                        height: 5.h,
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

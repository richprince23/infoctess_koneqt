import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/events_controller.dart';
import 'package:infoctess_koneqt/controllers/notification_service.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/status_snack.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

import '../models/event_model.dart';

class EventItem extends StatefulWidget {
  final Event event;
  const EventItem({required this.event, Key? key}) : super(key: key);

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
      closedBuilder: (context, action) => ClosedEventItem(event: widget.event),
      openBuilder: (context, action) => OpenEventItem(
        event: widget.event,
      ),
    );
  }
}

class ClosedEventItem extends StatelessWidget {
  final Event event;
  const ClosedEventItem({
    required this.event,
    Key? key,
  }) : super(key: key);

//function to check whether the event is upcoming or past
  String isUpcoming() {
    final now = DateTime.now();
    final eventDate = DateFormat("dd/MM/yyyy").parse(event.date!);
    if (now.compareTo(eventDate) < 0) {
      return "Upcoming";
    } else if (now.compareTo(eventDate) == 0) {
      return "Today";
    } else {
      return "Past";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.vh,
      margin: EdgeInsets.symmetric(vertical: 6.w),
      // padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: event.imgUrl != null
                      ? CachedNetworkImage(
                          imageUrl:
                              event.imgUrl ?? "https://via.placeholder.com/150",
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
                            Icons.calendar_month,
                            color: Colors.grey[600],
                            size: 50.w,
                          ),
                        ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Card(
                    // elevation: 5,
                    color: Colors.white.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        convertToMonthDayString(event.date!),
                        style: TextStyle(
                          fontSize: 14.sp + 1,
                          color: isUpcoming() == "Upcoming"
                              ? Colors.black
                              : isUpcoming() == "Today"
                                  ? Colors.blue
                                  : Colors.red,
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.sarabun(
                    fontSize: 18.sp + 1,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5.w),
                Text(
                  event.venue!,
                  style: TextStyle(
                    fontSize: 14.sp + 1,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OpenEventItem extends StatefulWidget {
  final Event event;
  const OpenEventItem({
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  State<OpenEventItem> createState() => _OpenEventItemState();
}

class _OpenEventItemState extends State<OpenEventItem> {
  late QuillController _controller;
  final scroller = ScrollController();
  final pageScroller = ScrollController();
  // late var myJSON;
  late bool hasBooked;
  @override
  void initState() {
    super.initState();
    // _controller = QuillController.basic();
    _controller = QuillController(
        document: Document.fromJson(jsonDecode(widget.event.body)),
        selection: const TextSelection.collapsed(offset: 0));
    hasBooked = widget.event.attendees!.contains(auth.currentUser!.uid);
    checkIfBooked();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  checkIfBooked() async {
    hasBooked = await hasUserRsvp(widget.event.id!);
    setState(() {});
  }

//function to book event
  Future bookEvent() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: Image.asset(
              'assets/images/preload.gif',
              height: 30.w,
              width: 30.w,
            ),
          );
        });
    try {
      await rsvpToEvent(widget.event.id!).then(
        (value) => NotificationService()
            .scheduleEventNotification(
              date: widget.event.date!,
              time: widget.event.time!.split("-").first.trim(),
            )
            .then(
              (value) => CustomSnackBar.show(
                context,
                message: "Event booked successfully",
              ),
            )
            .then(
              (value) => Navigator.pop(context),
            ),
      );
    } catch (e) {
      Navigator.pop(context);
      (value) => CustomSnackBar.show(
            context,
            message: "An error occured",
          );
    }
  }

//cancel booking
  Future cancelBooking() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Image.asset(
              'assets/images/preload.gif',
              height: 30.w,
              width: 30.w,
            ),
          );
        });
    try {
      await unrsvpToEvent(widget.event.id!)
          .then(
            (value) => CustomSnackBar.show(
              context,
              message: "Booking cancelled successfully",
            ),
          )
          .then(
            (value) => Navigator.pop(context),
          );
    } catch (e) {
      (value) => CustomSnackBar.show(
            context,
            message: "An error occured",
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: const DecoratedBox(
          decoration:
              ShapeDecoration(shape: CircleBorder(), color: Colors.white),
          child: BackButton(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: pageScroller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // padding: EdgeInsets.all(10.w),
              height: 30.vh,
              width: 100.vw,
              child: InkWell(
                onTap: () => widget.event.imgUrl != null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageViewer(
                            image: widget.event.imgUrl!,
                          ),
                        ),
                      )
                    : null,
                child: widget.event.imgUrl != null
                    ? CachedNetworkImage(
                        imageUrl: widget.event.imgUrl ??
                            "https://picsum.photos/250?image=5",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.only(
                            //     bottomLeft: Radius.circular(8.r),
                            //     bottomRight: Radius.circular(8.r)),
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
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.grey[600],
                            size: 50.w,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.calendar_month,
                          color: Colors.grey[600],
                          size: 50.w,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.w),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: ShapeDecoration(
                        shape: const StadiumBorder(),
                        color: cSec.withOpacity(0.1),
                      ),
                      // margin: EdgeInsets.only(left: 10.w),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.w),
                      child: Text(
                        "Mode: ${widget.event.mode!}",
                        style: TextStyle(
                          fontSize: 12.sp + 1,
                          color: Colors.black,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    Flexible(
                      child: Text(
                        widget.event.title,
                        style: GoogleFonts.sarabun(
                          fontSize: 20.sp + 1,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    // Spacer(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.w),
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 100.w),
              // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              width: 100.vw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: cSec.withOpacity(0.06),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      children: [
                        Text(
                          convertToDayString(widget.event.date!),
                          style: TextStyle(
                            fontSize: 12.sp + 1,
                            // color: cPri,
                          ),
                        ),
                        Text(
                          "${convertToMonthDayString(widget.event.date!).split(" ")[0].substring(0, 3)} ${convertToMonthDayString(widget.event.date!).split(" ")[1]}",
                          style: TextStyle(
                            fontSize: 12.sp + 1,
                            // color: cPri,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.w,
                    width: 0.5.w,
                    // color: cPri,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                  ),
                  Flexible(
                    child: Text(
                      widget.event.venue!,
                      // "${widget.event.venue!}, liberations hall edumfa",
                      style: TextStyle(
                        fontSize: 12.sp + 1,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                  Container(
                    height: 50.w,
                    width: 0.5.w,
                    color: cPri,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      children: [
                        Text(
                          widget.event.time!.split("-").first.trim(),
                          style: TextStyle(
                            fontSize: 12.sp + 1,
                            // color: cPri,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.event.time!.split("-").last.trim(),
                          style: TextStyle(
                            fontSize: 12.sp + 1,
                            // color: cPri,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Event Information",
                style: TextStyle(
                  fontSize: 14.sp + 1,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10.w),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(bottom: 80.w, left: 10.w, right: 10.w),
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
      bottomSheet: BottomSheet(
          elevation: 1,
          enableDrag: false,
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                bottom: 20.w,
                top: 10.w,
              ),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                color: cSec.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 60.w,
                      width: 100.vw,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(fontSize: 14.sp + 1),
                            ),
                            Text(
                              widget.event.fee == 0
                                  ? "Free"
                                  : "GHS ${widget.event.fee}",
                              style: TextStyle(
                                fontSize: 20.sp + 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 50.w,
                      width: 100.vw,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          elevation: 0,
                          backgroundColor: hasBooked == true ? cSec : cPri,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        onPressed: () async {
                          if (hasBooked == false) {
                            await bookEvent().then((value) => checkIfBooked());
                          } else {
                            await cancelBooking()
                                .then((value) => checkIfBooked());
                          }
                          // Navigator.pop(context);
                        },
                        child: Text(
                          hasBooked == false ? "Book A Seat" : "Cancel Booking",
                          style: TextStyle(
                              color: Colors.white, fontSize: 14.sp + 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/notiffications_screen.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:resize/resize.dart';

class AppBarScreen extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;

  AppBarScreen({Key? key, this.title})
      : preferredSize = Size.fromHeight(56.0.h),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Hi, ${curUser?.fullName!.split(' ')[0]} ",
        style: GoogleFonts.sarabun(fontSize: 14.sp),
      ),
      leadingWidth: 40.w,
      leading: InkWell(
        child: CircleAvatar(
          radius: 5.w,
          backgroundImage: CachedNetworkImageProvider(curUser?.avatar ?? ""),
        ),
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsSceen()));
          },
          iconSize: 20.w,
          icon: const Icon(CupertinoIcons.bell),
        )
      ],
    );
  }
}

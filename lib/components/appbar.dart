import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/notiffications_screen.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class AppBarScreen extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;

  AppBarScreen({Key? key, this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  // final _user =              Provider.of<UserProvider>(context, listen: false).getUserInfo();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // title: Builder(
      //   builder: (context) =>
      //       Consumer<UserProvider>(builder: (context, value, child) {
      //     return Text(
      //       "Hi, ${curUser?.fullName!.split(' ')[0] ?? 'User'}",
      //       style: GoogleFonts.sarabun(fontSize: 14.sp),
      //     );
      //   }),
      // ),
      leadingWidth: 40.w,
      
      surfaceTintColor: cSec.withOpacity(0.3),
      leading: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 5.w,
            backgroundImage: CachedNetworkImageProvider(curUser?.avatar ??
                "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle.png"),
          ),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/notiffications_screen.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';

class AppBarScreen extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;

  AppBarScreen({Key? key, this.title})
      : preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Hi, ${curUser!.fullName!.split(' ')[0]} ",
        style: GoogleFonts.sarabun(fontSize: 18),
      ),
      leadingWidth: 40,
      leading: InkWell(
        child: CircleAvatar(
          radius: 5,
          backgroundImage: CachedNetworkImageProvider(curUser!.avatar!),
        ),
        onTap: () {
          setUserDetails();
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
          icon: const Icon(CupertinoIcons.bell),
        )
      ],
    );
  }
}

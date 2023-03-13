import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/notiffications_screen.dart';

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
        'Hi, Richard',
        style: GoogleFonts.sarabun(fontSize: 18),
      ),
      leadingWidth: 40,
      leading: InkWell(
        child: const CircleAvatar(
            radius: 5,
            backgroundImage: CachedNetworkImageProvider(
              "https://images.unsplash.com/photo-1586523969132-b57cf9a85a70?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
            )),
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NotificationsSceen()));
          },
          icon: const Icon(CupertinoIcons.bell),
        )
      ],
    );
  }
}

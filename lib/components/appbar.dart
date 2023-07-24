import 'package:resize/resize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/screens/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      leadingWidth: 30.w,
      surfaceTintColor: cSec.withOpacity(0.3),
      leading: InkWell(
        child: CachedNetworkImage(
          width: 30.w,
          height: 30.w,
          fit: BoxFit.contain,
          imageUrl: curUser!.avatar!,
          imageBuilder: (context, imageProvider) => Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0.05,
      title: Text(
        title ?? "",
        style: TextStyle(
          fontSize: 16.sp + 1,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen()));
          },
          iconSize: 20.w,
          icon: const Icon(CupertinoIcons.search),
        ),
        // IconButton(
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => const NotificationsSceen()));
        //   },
        //   iconSize: 20.w,
        //   icon: const Icon(CupertinoIcons.bell),
        // )
      ],
    );
  }
}

import 'dart:io';
//  show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Card(
              margin: const EdgeInsets.all(12),
              elevation: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            width: 100,
                            imageUrl: curUser!.avatar!),
                      ),
                    ),
                    Text(
                      "${curUser!.fullName} ", // fullname
                      style: GoogleFonts.sarabun().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "@${curUser!.userName!} ", // @username
                      style: GoogleFonts.sarabun().copyWith(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${curUser!.classGroup} ", // class group
                      style: GoogleFonts.sarabun().copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shadowColor:
                              AppTheme.themeData(true, context).focusColor,
                          backgroundColor:
                              AppTheme.themeData(true, context).focusColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.pencil),
                        label: const Text("edit profile")),
                  ],
                ),
              ),
            ),
            Divider(
              color: AppTheme.themeData(true, context).backgroundColor,
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.globe,
                color: AppTheme.themeData(true, context).focusColor,
              ),
              title: Text(
                "UEW Website",
                style: GoogleFonts.sarabun().copyWith(
                  fontSize: 16,
                  color: AppTheme.themeData(true, context).focusColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.globe,
                color: AppTheme.themeData(true, context).focusColor,
              ),
              title: Text(
                "UEW VClass",
                style: GoogleFonts.sarabun().copyWith(
                  fontSize: 16,
                  color: AppTheme.themeData(true, context).focusColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.globe,
                color: AppTheme.themeData(true, context).focusColor,
              ),
              title: Text(
                "ITS Student Portal",
                style: GoogleFonts.sarabun().copyWith(
                  color: AppTheme.themeData(true, context).focusColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {},
            ),
            Divider(
              color: AppTheme.themeData(true, context).backgroundColor,
            ),
            ListTile(
              leading: Icon(
                Platform.isIOS
                    ? CupertinoIcons.settings
                    : Icons.settings_outlined,
                color: AppTheme.themeData(true, context).focusColor,
              ),
              title: Text(
                "Settings",
                style: GoogleFonts.sarabun().copyWith(
                  fontSize: 16,
                  color: AppTheme.themeData(true, context).focusColor,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.info_circle,
                color: AppTheme.themeData(true, context).focusColor,
              ),
              title: Text(
                "About",
                style: GoogleFonts.sarabun().copyWith(
                  fontSize: 16,
                  color: AppTheme.themeData(true, context).focusColor,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.arrow_right_square,
                color: AppTheme.themeData(true, context).focusColor,
              ),
              title: Text(
                "Exit",
                style: GoogleFonts.sarabun().copyWith(
                  fontSize: 16,
                  color: AppTheme.themeData(true, context).focusColor,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

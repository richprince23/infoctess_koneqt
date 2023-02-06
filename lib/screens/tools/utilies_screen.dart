import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  //TODO: Change icons to custom images

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // color: Colors.blue,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.blue, Colors.pink],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
          child: GridView.count(
            cacheExtent: 40,
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              Card(
                surfaceTintColor: Colors.white.withOpacity(0.5),
                color: AppTheme.themeData(false, context)
                    .cardColor
                    .withOpacity(0.5),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(CupertinoIcons.divide,
                          size: 50,
                          color: AppTheme.themeData(false, context)
                              .primaryColorLight),
                      Text(
                        "GPA Calculator",
                        style: GoogleFonts.sarabun(
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                surfaceTintColor: Colors.white.withOpacity(0.5),
                color: AppTheme.themeData(false, context)
                    .cardColor
                    .withOpacity(0.5),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(CupertinoIcons.book,
                          size: 50,
                          color: AppTheme.themeData(false, context)
                              .primaryColorLight),
                      Text(
                        "My Courses",
                        style: GoogleFonts.sarabun(
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                surfaceTintColor: Colors.white.withOpacity(0.5),
                color: AppTheme.themeData(false, context)
                    .cardColor
                    .withOpacity(0.5),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(CupertinoIcons.calendar,
                          size: 50,
                          color: AppTheme.themeData(false, context)
                              .primaryColorLight),
                      Text(
                        "My Schedules",
                        style: GoogleFonts.sarabun(
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                surfaceTintColor: Colors.white.withOpacity(0.5),
                color: AppTheme.themeData(false, context)
                    .cardColor
                    .withOpacity(0.5),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(CupertinoIcons.pencil_outline,
                          size: 50,
                          color: AppTheme.themeData(false, context)
                              .primaryColorLight),
                      Text(
                        "My Notes",
                        style: GoogleFonts.sarabun(
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                surfaceTintColor: Colors.white.withOpacity(0.5),
                color: AppTheme.themeData(false, context)
                    .cardColor
                    .withOpacity(0.5),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(CupertinoIcons.link,
                          size: 50,
                          color: AppTheme.themeData(false, context)
                              .primaryColorLight),
                      Text(
                        "Go to PDFDrive",
                        style: GoogleFonts.sarabun(
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                surfaceTintColor: Colors.white.withOpacity(0.5),
                color: AppTheme.themeData(false, context)
                    .cardColor
                    .withOpacity(0.5),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(CupertinoIcons.bubble_left_bubble_right,
                          size: 50,
                          color: AppTheme.themeData(false, context)
                              .primaryColorLight),
                      Text(
                        "AI StudyMate",
                        style: GoogleFonts.sarabun(
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

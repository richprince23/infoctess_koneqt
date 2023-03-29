import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // color: Colors.blue,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.pink],
            stops: [0.2, 1],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
          child: GridView.count(
            cacheExtent: 40,
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              UtilItem(
                icon: CupertinoIcons.divide,
                title: 'GPA Calculator',
                route: 'gpa-calculator',
              ),
              UtilItem(
                icon: CupertinoIcons.book,
                title: 'My Courses',
                route: 'my-courses',
              ),
              UtilItem(
                icon: CupertinoIcons.calendar,
                title: 'My Schedules',
                route: 'my-schedules',
              ),
              UtilItem(
                icon: CupertinoIcons.pencil_outline,
                title: 'My Notes',
                route: 'my-notes',
              ),
              UtilItem(
                icon: CupertinoIcons.person_2,
                title: 'AI StudyMate',
                route: 'ai-studymate',
              ),
              UtilItem(
                icon: CupertinoIcons.photo,
                title: 'AI Imager',
                route: 'ai-imager',
              ),
              UtilItem(
                icon: CupertinoIcons.list_number,
                title: 'Practice Quiz',
                // route: '',
              ),
              Card(
                surfaceTintColor: Colors.white.withOpacity(0.5),
                color: AppTheme.themeData(false, context)
                    .cardColor
                    .withOpacity(0.5),
                child: InkWell(
                  onTap: () async {
                    await canLaunchUrlString('https://www.pdfdrive.com/')
                        ? await launchUrlString(
                            'https://www.pdfdrive.com/',
                            webViewConfiguration: const WebViewConfiguration(
                              enableDomStorage: true,
                              enableJavaScript: true,
                            ),
                            mode: LaunchMode.inAppWebView,
                          )
                        : throw 'Could not launch https://www.pdfdrive.com/';
                  },
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
              UtilItem(
                icon: CupertinoIcons.hammer,
                title: 'Other Resources',
                // route: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UtilItem extends StatelessWidget {
  IconData icon;
  String title;
  String? route;
  UtilItem({
    Key? key,
    required this.icon,
    required this.title,
    this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white.withOpacity(0.5),
      color: AppTheme.themeData(false, context).cardColor.withOpacity(0.5),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/$route'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon,
                size: 50,
                color: AppTheme.themeData(false, context).primaryColorLight),
            Text(
              title,
              style: GoogleFonts.sarabun(
                  color: AppTheme.themeData(false, context).primaryColorLight,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/controllers/notification_service.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:infoctess_koneqt/env.dart';

class UtilitiesScreen extends StatefulWidget {
  const UtilitiesScreen({super.key});

  @override
  State<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  @override
  void initState() {
    _initializeRemoteConfig();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initializeRemoteConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
  }

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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
          child: GridView.count(
            cacheExtent: 40,
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 10.h,
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
                icon: CupertinoIcons.doc_text,
                title: 'Passco',
                // route: '',
              ),
              UtilItem(
                icon: CupertinoIcons.money_dollar,
                title: 'My Dues',
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
                          size: 50.h,
                          color: AppTheme.themeData(false, context)
                              .primaryColorLight),
                      Text(
                        "Go to PDFDrive",
                        style: GoogleFonts.sarabun(
                            color: AppTheme.themeData(false, context)
                                .primaryColorLight,
                            fontSize: 16.sp + 1),
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
              // InkWell(
              //   onTap: () => NotificationService().showNotification(
              //       title: "Test", body: "Testing instant notifications"),
              //   child: const Icon(Icons.alarm),
              // ),
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
                size: 50.h,
                color: AppTheme.themeData(false, context).primaryColorLight),
            Text(
              title,
              style: GoogleFonts.sarabun(
                  color: AppTheme.themeData(false, context).primaryColorLight,
                  fontSize: 16.sp + 1),
            ),
          ],
        ),
      ),
    );
  }
}

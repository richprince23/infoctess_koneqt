import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/widgets/list_item.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  Future gotoPage(String url) async {
    await canLaunchUrlString(url)
        ? await launchUrlString(
            url,
            webViewConfiguration: const WebViewConfiguration(
              enableDomStorage: true,
              enableJavaScript: true,
            ),
            mode: LaunchMode.inAppWebView,
          )
        : throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    //  implement routing and on tap events
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding:
            EdgeInsets.only(left: 20.w, top: 40.w, bottom: 20.w, right: 20.w),
        children: [
          InkWell(
            onTap: () {
              // Navigator.pushNamed(context, "/profile");
            },
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                color: cSec.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: CachedNetworkImageProvider(
                      auth.currentUser!.photoURL ??
                          "https://i.pravatar.cc/150?img=3",
                      errorListener: () =>
                          const Icon(Icons.account_circle, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          child: Text(
                            curUser?.fullName!.split(" ")[0] ?? "User",
                            style: GoogleFonts.sarabun().copyWith(
                              fontSize: 16.sp + 1,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          child: Text(
                            "@${curUser?.userName}",
                            style: GoogleFonts.sarabun().copyWith(
                              fontSize: 12.sp + 1,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // Divider(
          //   color: cPri,
          // ),
          SizedBox(height: 10.w),
          // const ListItem(
          //     icon: Icons.person, title: "Profile", route: "/profile"),
          const ListItem(
            icon: Icons.show_chart,
            title: "My Activity",
            route: "/my-activity",
          ),
          const ListItem(
            icon: Icons.calendar_month,
            title: "Calendar",
            route: "/calendar",
          ),
          const ListItem(
            icon: Icons.bookmark,
            title: "Saved Items",
            route: "/bookmarks",
          ),
          // Divider(
          //   color: cPri,
          // ),
          // if (curUser?.isAdmin == true)
          //   const ListItem(
          //     icon: Icons.manage_accounts,
          //     title: "Manage Users",
          //     route: "/manage-users",
          //   ),
          if (curUser?.isAdmin == true)
            const ListItem(
              icon: Icons.event,
              title: "Manage Events",
              route: "/manage-events",
            ),
          // const ListItem(icon: Icons.settings, title: "Settings"),
          Divider(
            color: cPri,
          ),
          ListItem(
            icon: CupertinoIcons.globe,
            title: "OSIS Portal",
            onTap: () async {
              await gotoPage("https://osissip.osis.online/");
            },
          ),
          ListItem(
            icon: CupertinoIcons.globe,
            title: "Infoctess",
            onTap: () async {
              await gotoPage("https://infoctess-uew.org/");
            },
          ),
          ListItem(
            icon: CupertinoIcons.globe,
            title: "UEW VClass",
            onTap: () async {
              await gotoPage("https://vclass.uew.edu.gh/");
            },
          ),
          Divider(
            color: cPri,
          ),
          ListItem(
            icon: Icons.info,
            title: "About",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationIcon: Image.asset(
                  "assets/images/infoctess_logo_bg.png",
                  width: 30.w,
                ),
                applicationLegalese: " Copyright (c) 2023 ARK Softwarez",
                applicationVersion: "1.0.2",
              );
            },
          ),
          ListItem(
            icon: Icons.exit_to_app,
            title: "Logout",
            onTap: () async {
              Navigator.pop(context);
              try {
                await auth.signOut().then(
                      (value) => {
                        Provider.of<UserProvider>(context, listen: false)
                            .clearUserDetails()
                            .then(
                              (value) => Navigator.pushNamedAndRemoveUntil(
                                  context, "/login", (route) => false),
                            ),
                      },
                    );
              } catch (e) {
                // debugPrint(e.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}

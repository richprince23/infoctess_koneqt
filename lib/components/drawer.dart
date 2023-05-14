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

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Drawer(
    //   child: Padding(
    //     padding: EdgeInsets.all(12.0.h),
    //     child: ListView(
    //       children: [
    //         Card(
    //           margin: EdgeInsets.all(8.h),
    //           elevation: 1,
    //           child: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
    //             child: Column(
    //               children: [
    //                 CircleAvatar(
    //                   radius: 50.h,
    //                   foregroundImage: CachedNetworkImageProvider(
    //                     // fit: BoxFit.fill,
    //                     maxWidth: 100.h.ceil(),
    //                     curUser?.avatar?.isNotEmpty == true
    //                         ? curUser!.avatar!
    //                         : "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle.png",
    //                   ),
    //                 ),
    //                 Text(
    //                   "${curUser?.fullName ?? 'Someone'} ", // fullname
    //                   style: GoogleFonts.sarabun().copyWith(
    //                     fontSize: 16.sp,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                   textAlign: TextAlign.center,
    //                   overflow: TextOverflow.ellipsis,
    //                   maxLines: 2,
    //                 ),
    //                 Text(
    //                   "@${curUser?.userName ?? 'someone'} ", // @username
    //                   style: GoogleFonts.sarabun().copyWith(
    //                     fontSize: 14.sp,
    //                     color: Colors.black54,
    //                     fontWeight: FontWeight.w400,
    //                   ),
    //                   maxLines: 2,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //                 Text(
    //                   "${curUser?.classGroup ?? 'Group 0'} ", // class group
    //                   style: GoogleFonts.sarabun().copyWith(
    //                     fontSize: 16.sp,
    //                     fontWeight: FontWeight.w400,
    //                   ),
    //                 ),
    //                 SizedBox(height: 20.h),
    //                 ElevatedButton.icon(
    //                   style: ElevatedButton.styleFrom(
    //                     shadowColor:
    //                         AppTheme.themeData(true, context).focusColor,
    //                     backgroundColor:
    //                         AppTheme.themeData(true, context).focusColor,
    //                     foregroundColor: Colors.white,
    //                     maximumSize: Size(
    //                       100.w < 140 ? 140 : 100.w,
    //                       40.h < 40 ? 40 : 40.h,
    //                     ),
    //                   ),
    //                   onPressed: () {},
    //                   icon: const Icon(CupertinoIcons.pencil),
    //                   label: const Text("edit profile"),
    //                 ),
    //                 OutlinedButton.icon(
    //                   onPressed: () async {
    //                     try {
    //                       await auth.signOut().then(
    //                             (value) => {
    //                               Provider.of<UserProvider>(context,
    //                                       listen: false)
    //                                   .clearUserDetails()
    //                                   .then((value) =>
    //                                       Provider.of<UserProvider>(context,
    //                                               listen: false)
    //                                           .setLoggedIn(false)
    //                                           .then((value) =>
    //                                               debugPrint("logged out"))),
    //                               Navigator.pushNamedAndRemoveUntil(
    //                                   context, "/login", (route) => false),
    //                             },
    //                           );
    //                     } catch (e) {
    //                       debugPrint(e.toString());
    //                     }
    //                   },
    //                   icon: const Icon(CupertinoIcons.power),
    //                   label: Text(
    //                     "Logout",
    //                     style: GoogleFonts.sarabun().copyWith(
    //                       fontSize: 12.sp,
    //                       color: AppTheme.themeData(true, context).focusColor,
    //                       fontWeight: FontWeight.w400,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Divider(
    //           color: cPri,
    //         ),
    //         ListTile(
    //           leading: Icon(
    //             CupertinoIcons.globe,
    //             color: AppTheme.themeData(true, context).focusColor,
    //           ),
    //           title: Text(
    //             "UEW Website",
    //             style: GoogleFonts.sarabun().copyWith(
    //               fontSize: 16.sp,
    //               color: AppTheme.themeData(true, context).focusColor,
    //               fontWeight: FontWeight.w400,
    //             ),
    //           ),
    //           onTap: () {},
    //         ),
    //         ListTile(
    //           leading: Icon(
    //             CupertinoIcons.globe,
    //             color: AppTheme.themeData(true, context).focusColor,
    //           ),
    //           title: Text(
    //             "UEW VClass",
    //             style: GoogleFonts.sarabun().copyWith(
    //               fontSize: 16.sp,
    //               color: AppTheme.themeData(true, context).focusColor,
    //               fontWeight: FontWeight.w400,
    //             ),
    //           ),
    //           onTap: () {},
    //         ),
    //         ListTile(
    //           leading: Icon(
    //             CupertinoIcons.globe,
    //             color: AppTheme.themeData(true, context).focusColor,
    //           ),
    //           title: Text(
    //             "OSIS Portal",
    //             style: GoogleFonts.sarabun().copyWith(
    //               color: AppTheme.themeData(true, context).focusColor,
    //               fontSize: 16.sp,
    //               fontWeight: FontWeight.w400,
    //             ),
    //           ),
    //           onTap: () {},
    //         ),
    //         Divider(
    //           color: cPri,
    //         ),
    //         ListTile(
    //           leading: Icon(
    //             Platform.isIOS
    //                 ? CupertinoIcons.settings
    //                 : Icons.settings_outlined,
    //             color: AppTheme.themeData(true, context).focusColor,
    //           ),
    //           title: Text(
    //             "Settings",
    //             style: GoogleFonts.sarabun().copyWith(
    //               fontSize: 16.sp,
    //               color: AppTheme.themeData(true, context).focusColor,
    //             ),
    //           ),
    //           onTap: () {},
    //         ),
    //         ListTile(
    //           leading: Icon(
    //             CupertinoIcons.info_circle,
    //             color: AppTheme.themeData(true, context).focusColor,
    //           ),
    //           title: Text(
    //             "About",
    //             style: GoogleFonts.sarabun().copyWith(
    //               fontSize: 16.sp,
    //               color: AppTheme.themeData(true, context).focusColor,
    //             ),
    //           ),
    //           onTap: () {},
    //         ),
    //         ListTile(
    //           leading: Icon(
    //             CupertinoIcons.arrow_right_square,
    //             color: AppTheme.themeData(true, context).focusColor,
    //           ),
    //           title: Text(
    //             "Exit",
    //             style: GoogleFonts.sarabun().copyWith(
    //               fontSize: 16.sp,
    //               color: AppTheme.themeData(true, context).focusColor,
    //             ),
    //           ),
    //           onTap: () {},
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    // TODO: implement routing and on tap events
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding:
            EdgeInsets.only(left: 20.w, top: 40.h, bottom: 20.h, right: 20.w),
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
                      curUser?.avatar ??
                          "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle.png",
                      errorListener: () =>
                          Image.network("https://picsum.photos/id/2/367/267"),
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
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          child: Text(
                            curUser?.emailAddress ?? "email",
                            style: GoogleFonts.sarabun().copyWith(
                              fontSize: 12.sp,
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
          Divider(
            color: cPri,
          ),
          // const ListItem(icon: Icons.home, title: "Home", route: "/main"),
          const ListItem(
              icon: Icons.person, title: "Profile", route: "/profile"),
          const ListItem(
              icon: Icons.show_chart, title: "My Activity", route: "/my-posts"),
          const ListItem(
              icon: Icons.calendar_today,
              title: "Calendar",
              route: "/calendar"),
          const ListItem(icon: Icons.bookmark, title: "Saved Items"),
          const ListItem(icon: Icons.settings, title: "Settings"),
          const ListItem(icon: Icons.info, title: "About"),
          Divider(
            color: cPri,
          ),
          ListItem(
            icon: CupertinoIcons.globe,
            title: "OSIS Portal",
            onTap: () {},
          ),
          ListItem(
            icon: CupertinoIcons.globe,
            title: "Infoctess Website",
            onTap: () {},
          ),
          const ListItem(
            icon: CupertinoIcons.globe,
            title: "UEW VClass",
          ),
          Divider(
            color: cPri,
          ),
          ListItem(
            icon: Icons.exit_to_app,
            title: "Logout",
            onTap: () async {
              try {
                await auth.signOut().then(
                      (value) => {
                        Provider.of<UserProvider>(context, listen: false)
                            .clearUserDetails()
                            .then((value) => Provider.of<UserProvider>(context,
                                    listen: false)
                                .setLoggedIn(false)
                                .then((value) => debugPrint("logged out"))),
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/login", (route) => false),
                      },
                    );
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}

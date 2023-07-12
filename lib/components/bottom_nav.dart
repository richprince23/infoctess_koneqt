import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/widgets/nav_item.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
      child: NavigationBar(
        // backgroundColor: cPri.withOpacity(0.5),
        surfaceTintColor: cSec.withOpacity(0.8),
        elevation: 3,
        selectedIndex: context.watch<PageControl>().pageIndex,
        height: 50.h,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          SizedBox(
            height: 50.h,
            child: InkWell(
              // iconSize: 16,
              onTap: () {
                setState(() {
                  pageIndex = 0;
                  Provider.of<PageControl>(context, listen: false)
                      .setPageIndex(0);
                });
              },
              child: pageIndex == 0
                  ? NavItem(
                      label: "Explore",
                      icon: CupertinoIcons.globe,
                    )
                  : Icon(
                      CupertinoIcons.globe,
                      color: Colors.black,
                      size: 24.w,
                    ),
            ),
          ),
          SizedBox(
            height: 50.h,
            child: InkWell(
              // iconSize: 16,
              onTap: () {
                setState(() {
                  pageIndex = 1;
                  Provider.of<PageControl>(context, listen: false)
                      .setPageIndex(1);
                });
              },
              child: pageIndex == 1
                  ? NavItem(
                      label: "Social",
                      icon: CupertinoIcons.person_3_fill,
                    )
                  : Icon(
                      CupertinoIcons.person_3,
                      color: Colors.black,
                      size: 24.w,
                    ),
            ),
          ),
          SizedBox(
            height: 50.h,
            child: InkWell(
              // iconSize: 16,
              onTap: () {
                setState(() {
                  pageIndex = 2;
                  Provider.of<PageControl>(context, listen: false)
                      .setPageIndex(2);
                });
              },
              child: pageIndex == 2
                  ? NavItem(
                      label: "Utilities", icon: CupertinoIcons.briefcase_fill)
                  : Icon(
                      CupertinoIcons.briefcase,
                      color: Colors.black,
                      size: 24.w,
                    ),
            ),
          ),
          SizedBox(
            height: 50.h,
            // width: size.height * 0.06,
            child: InkWell(
              // iconSize: 16,
              onTap: () {
                setState(() {
                  pageIndex = 3;
                  Provider.of<PageControl>(context, listen: false)
                      .setPageIndex(3);
                });
              },
              child: pageIndex == 3
                  ? NavItem(
                      label: "Chats",
                      icon: CupertinoIcons.chat_bubble_2_fill,
                    )
                  : Icon(
                      CupertinoIcons.chat_bubble_2,
                      color: Colors.black,
                      size: 24.w,
                    ),
            ),
          ),
          SizedBox(
            height: 50.h,
            // width: size.height * 0.06,
            child: InkWell(
              // iconSize: 16,
              onTap: () {
                setState(() {
                  pageIndex = 4;
                  Provider.of<PageControl>(context, listen: false)
                      .setPageIndex(4);
                });
              },
              child: pageIndex == 4
                  ? NavItem(
                      label: "Profle",
                      icon: CupertinoIcons.person_alt_circle_fill,
                    )
                  : Icon(
                      CupertinoIcons.person_alt_circle,
                      color: Colors.black,
                      size: 24.w,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/controllers/page_controller.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/nav_item.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: AppTheme.themeData(false, context).backgroundColor,
        elevation: 2,
        selectedIndex: context.watch<PageControl>().pageIndex,
        height: 50,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          SizedBox(
            height: 50,
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
                      label: "Home",
                      icon: CupertinoIcons.house_fill,
                    )
                  : const Icon(CupertinoIcons.house, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 50,
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
                  ? NavItem(label: "Community", icon: CupertinoIcons.news_solid)
                  : const Icon(CupertinoIcons.news, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 50,
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
                  : const Icon(CupertinoIcons.briefcase, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 50,
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
                      label: "Messages",
                      icon: CupertinoIcons.envelope_open_fill)
                  : const Icon(CupertinoIcons.envelope, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';

class NavItem extends StatelessWidget {
  String label;
  IconData icon;

  NavItem({Key? key, required this.label, required this.icon})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        // color: kmainCol,
        // borderRadius: BorderRadius.circular(20),
        border: Border(
          bottom: BorderSide(color: cSec),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: cSec,
            size: 16.w,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp + 1,
              // color: AppTheme.themeData(false, context).primaryColor,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

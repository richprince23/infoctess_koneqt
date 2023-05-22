import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:resize/resize.dart';

class ListItem extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? route;
  final Function? onTap;
  const ListItem({
    Key? key,
    this.icon,
    this.title,
    this.route,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(
          icon,
          color: cPri,
        ),
        title: Text(
          title ?? "",
          style: GoogleFonts.sarabun().copyWith(
            fontSize: 16.sp,
            color: Colors.grey[800],
            fontWeight: FontWeight.w400,
          ),
        ),
        //if onTap is null, then it will push to route
        onTap: () => onTap != null
            ? onTap!()
            : Navigator.popAndPushNamed(context, route?.toString() ?? "/main"),
      ),
    );
  }
}

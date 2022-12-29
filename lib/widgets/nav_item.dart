import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

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
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        // color: kmainCol,
        // borderRadius: BorderRadius.circular(20),
        border: Border(
          bottom: BorderSide(
              color: AppTheme.themeData(false, context).focusColor, width: 3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppTheme.themeData(false, context).focusColor,
            size: 16,
          ),
          Text(label,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.themeData(false, context).primaryColor,
              )),
        ],
      ),
    );
  }
}

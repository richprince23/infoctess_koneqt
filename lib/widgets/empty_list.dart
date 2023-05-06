import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class EmptyList extends StatelessWidget {
  String text;

  EmptyList({
    Key? key,
    this.text = "No data found!",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 15.vh,
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.all(30.r),
        padding: EdgeInsets.all(20.r),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/no_data.png",
              width: 50.h,
              height: 50.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 13.sp, color: Colors.black),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

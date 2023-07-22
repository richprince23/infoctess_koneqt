import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class EmptyList extends StatelessWidget {
  final String text;

  const EmptyList({
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
              width: 50.w,
              height: 50.w,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 13.sp + 1, color: Colors.black),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

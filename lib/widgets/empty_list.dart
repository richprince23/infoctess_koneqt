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
      height: 15.vh,
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(30.r),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          color: Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}

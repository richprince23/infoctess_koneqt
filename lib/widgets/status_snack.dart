import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:resize/resize.dart';

class CustomSnackBar extends StatefulWidget {
  final String message;

  const CustomSnackBar({Key? key, required this.message}) : super(key: key);

  @override
  State<CustomSnackBar> createState() => _CustomSnackBarState();

  static void show(BuildContext context,
      {required String message, Animation<double>? animation}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cSec,
        dismissDirection: DismissDirection.down,
        // width: 60.vw,
        duration: const Duration(seconds: 3),
        animation: animation,
        showCloseIcon: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        // padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 50.w),
        // margin: EdgeInsets.only(bottom: 50.w),
        elevation: 5,
        content: Align(
          alignment: Alignment.center,
          child: Text(message),
        ),
      ),
    );
  }
}

class _CustomSnackBarState extends State<CustomSnackBar>
    with TickerProviderStateMixin {
  late final Animation<double> animation1;

  @override
  void initState() {
    super.initState();
    animation1 = CurvedAnimation(
      parent: AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      ),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

///enum to define the type of alert icon
enum AlertStyle { warning, info, success, error }

class CustomDialog extends StatelessWidget {
  final String? title;
  final String message;
  final AlertStyle? alertStyle;
  const CustomDialog(
      {Key? key,
      this.title,
      required this.message,
      this.alertStyle = AlertStyle.info})
      : super(key: key);

  ///show a normal dialog with an OK button
  ///[title] is the title of the dialog
  ///[message] is the message to be displayed
  static void show(BuildContext context,
      {String? title, required String message, AlertStyle? alertStyle}) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        alertStyle: alertStyle,
      ),
    );
  }

  ///show a dialog with an action button
  ///[title] is the title of the dialog
  ///[message] is the message to be displayed
  ///[action] is the action to be performed when the action button is pressed
  ///[actionText] is the text to be displayed on the action button
  ///[actionText] defaults to "Proceed"

  static void showWithAction(BuildContext context,
      {String? title,
      required String message,
      required VoidCallback action,
      String? actionText = "Proceed"}) {
    showDialog(
      context: context,
      builder: (context) => CustomActionDialog(
        title: title,
        message: message,
        action: action,
        actionText: actionText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AlertDialog(
            title: Text(title ?? "", style: TextStyle(fontSize: 16.sp + 1)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  alertStyle == AlertStyle.warning
                      ? Icons.warning
                      : alertStyle == AlertStyle.info
                          ? Icons.info
                          : alertStyle == AlertStyle.success
                              ? Icons.check_circle
                              : Icons.error,
                  color: alertStyle == AlertStyle.warning
                      ? Colors.amber
                      : alertStyle == AlertStyle.info
                          ? Colors.blue
                          : alertStyle == AlertStyle.success
                              ? Colors.green
                              : Colors.red,
                  size: 40.sp,
                ),
                SizedBox(height: 10.w),
                Text(message, style: TextStyle(fontSize: 16.sp)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK',
                    style: TextStyle(
                        fontSize: 16.sp + 1, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: Text(title ?? "", style: TextStyle(fontSize: 16.sp + 1)),
            content: Column(
              children: [
                Icon(
                  alertStyle == AlertStyle.warning
                      ? Icons.warning
                      : alertStyle == AlertStyle.info
                          ? Icons.info
                          : alertStyle == AlertStyle.success
                              ? Icons.check_circle
                              : Icons.error,
                  color: alertStyle == AlertStyle.warning
                      ? Colors.amber
                      : alertStyle == AlertStyle.info
                          ? Colors.blue
                          : alertStyle == AlertStyle.success
                              ? Colors.green
                              : Colors.red,
                  size: 40.sp,
                ),
                SizedBox(height: 10.w),
                Text(message, style: TextStyle(fontSize: 16.sp)),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK', style: TextStyle(fontSize: 16.sp + 1)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
  }
}

class CustomActionDialog extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback action;
  final String? actionText;
  final AlertStyle? alertStyle;

  const CustomActionDialog({
    Key? key,
    this.title,
    required this.message,
    required this.action,
    this.actionText = "Proceed",
    this.alertStyle = AlertStyle.warning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AlertDialog(
            title: Text(title ?? "Confirmation",
                style: TextStyle(fontSize: 16.sp + 1)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  alertStyle == AlertStyle.warning
                      ? Icons.warning
                      : alertStyle == AlertStyle.info
                          ? Icons.info
                          : alertStyle == AlertStyle.success
                              ? Icons.check_circle
                              : Icons.error,
                  color: alertStyle == AlertStyle.warning
                      ? Colors.amber
                      : alertStyle == AlertStyle.info
                          ? Colors.blue
                          : alertStyle == AlertStyle.success
                              ? Colors.green
                              : Colors.red,
                  size: 40.sp,
                ),
                SizedBox(height: 10.w),
                Text(message, style: TextStyle(fontSize: 16.sp)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(actionText!,
                    style: TextStyle(
                        fontSize: 16.sp + 1, fontWeight: FontWeight.bold)),
                onPressed: () {
                  action();
                  Navigator.of(context, rootNavigator: true).pop(true);
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(fontSize: 16.sp + 1)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: Text(title ?? "Confirmation",
                style: TextStyle(fontSize: 16.sp + 1)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  alertStyle == AlertStyle.warning
                      ? Icons.warning
                      : alertStyle == AlertStyle.info
                          ? Icons.info
                          : alertStyle == AlertStyle.success
                              ? Icons.check_circle
                              : Icons.error,
                  color: alertStyle == AlertStyle.warning
                      ? Colors.amber
                      : alertStyle == AlertStyle.info
                          ? Colors.blue
                          : alertStyle == AlertStyle.success
                              ? Colors.green
                              : Colors.red,
                  size: 40.sp,
                ),
                Text(message, style: TextStyle(fontSize: 16.sp)),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(actionText!, style: TextStyle(fontSize: 16.sp + 1)),
                onPressed: () {
                  action();
                  Navigator.of(context, rootNavigator: true).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: Text('Cancel', style: TextStyle(fontSize: 16.sp + 1)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
              ),
            ],
          );
  }
}

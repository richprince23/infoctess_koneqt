import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String message;

  const CustomDialog({Key? key, this.title, required this.message})
      : super(key: key);

  static void show(BuildContext context,
      {String? title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
      ),
    );
  }

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
          actionText: actionText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AlertDialog(
            title: Text(title ?? ""),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: Text(title ?? ""),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
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

  const CustomActionDialog({
    Key? key,
    this.title,
    required this.message,
    required this.action,
    this.actionText = "Proceed",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AlertDialog(
            title: Text(title ?? "Confirmation",
                style: TextStyle(fontSize: 18.sp)),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(actionText!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  action();
                  Navigator.of(context, rootNavigator: true).pop(true);
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: Text(title ?? "Confirmation"),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(actionText!),
                onPressed: () {
                  action();
                  Navigator.of(context, rootNavigator: true).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
              ),
            ],
          );
  }
}

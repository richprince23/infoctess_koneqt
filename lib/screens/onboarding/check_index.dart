import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

class CheckAccessPage extends StatefulWidget {
  const CheckAccessPage({super.key});

  @override
  State<CheckAccessPage> createState() => _CheckAccessPageState();
}

class _CheckAccessPageState extends State<CheckAccessPage> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String response = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text("Verify"),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.lock, size: sw24(context), color: cSec),
                SizedBox(height: 10.h),
                Text(
                  "Please verify that you are a member of INFOCTESS, UEW",
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Form(
                  key: _formKey,
                  child: InputControl(
                    hintText: "Enter your Index Number",
                    controller: _controller,
                    type: TextInputType.number,
                    validator: (value) {
                      if (value!.length < 9) {
                        return "Please enter a valid index number";
                      }
                      return null;
                    },
                  ),
                ),
                response.isEmpty
                    ? SizedBox(height: 10.h)
                    : const SizedBox.shrink(),
                response != ""
                    ? Text(
                        "$response ",
                        style: TextStyle(color: Colors.red, fontSize: 12.sp),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: sh1(context)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: btnLarge(context),
                      backgroundColor:
                          AppTheme.themeData(false, context).backgroundColor,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: f18(context))),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() {
                      response = "";
                    });
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => Center(
                        // title: const Text("Verification"),
                        child: Image.asset(
                          "assets/images/preload.gif",
                          height: 50.h,
                          width: 50.h,
                        ),
                      ),
                    );
                    try {
                      await checkUserAccess((_controller.text)).then(
                        (value) async {
                          if (value != null) {
                            try {
                              await Auth()
                                  .checkUserExists(
                                int.parse(_controller.text),
                              )
                                  .then(
                                (value) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  if (value == false) {
                                    StatusAlert.show(
                                      context,
                                      title: "Verified",
                                      configuration: const IconConfiguration(
                                        icon: Icons.done,
                                      ),
                                    );
                                    // Navigator.pop(context);
                                    Navigator.popAndPushNamed(
                                      context,
                                      "/onboarding",
                                    );
                                  } else {
                                    setState(() {
                                      response = "User already exists";
                                    });
                                  }
                                },
                              );
                            } catch (e) {
                              Navigator.of(context, rootNavigator: true).pop();
                              Platform.isAndroid
                                  ? showDialog(
                                      context: context,
                                      builder: (context) => const CustomDialog(
                                        message:
                                            "An error occurred while performing your request",
                                      ),
                                    )
                                  : showCupertinoDialog(
                                      context: context,
                                      builder: (context) => const CustomDialog(
                                        message:
                                            "An error occured while performing your request",
                                      ),
                                    );
                              setState(() {
                                response = "An error occured. Please try again";
                              });
                              // Navigator.pop(context);
                            }
                            setState(() {
                              response = "";
                            });
                          } else {
                            Navigator.of(context, rootNavigator: true).pop();
                            setState(() {
                              response =
                                  "Member not found. Please ensure you have registered with Infoctess.If you have, contact the admin to reslove this.";
                            });
                            // Navigator.pop(context);
                          }
                        },
                      );
                    } catch (e) {
                      Navigator.of(context, rootNavigator: true).pop();
                      Platform.isAndroid
                          ? showDialog(
                              context: context,
                              builder: (context) => const CustomDialog(
                                message:
                                    "An error occurred while performing your request",
                              ),
                            )
                          : showCupertinoDialog(
                              context: context,
                              builder: (context) => const CustomDialog(
                                message:
                                    "An error occured while performing your request",
                              ),
                            );
                      setState(() {
                        response = "An error occured. Please try again";
                      });
                    }
                  },
                  child: const Text("verify"),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

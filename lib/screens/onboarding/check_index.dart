import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
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
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text("Verify", style: TextStyle(fontSize: 18.sp + 1)),
          toolbarHeight: 48.h,
          leading: IconButton(
            icon: const BackButtonIcon(),
            iconSize: 24.sp,
            onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(40.0.w),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.lock, size: 24.sp, color: cSec),
                  SizedBox(height: 10.w),
                  Text(
                    "Please verify that you are a member of INFOCTESS-UEW",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16.sp + 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.w),
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
                  // response.isEmpty
                  //     ? SizedBox(height: 10.h)
                  //     : const SizedBox.shrink(),
                  // response != ""
                  //     ? Text(
                  //         "$response ",
                  //         style:
                  //             TextStyle(color: Colors.red, fontSize: 12.sp + 1),
                  //       )
                  //     : const SizedBox.shrink(),
                  SizedBox(height: sh1(context)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: btnLarge(context),
                        backgroundColor: cPri,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 18.sp)),
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
                            height: 30.w,
                            width: 30.w,
                          ),
                        ),
                      );
                      try {
                        await checkUserAccess(_controller.text).then(
                          (value) async {
                            if (value != null) {
                              try {
                                await Auth()
                                    .checkUserExists(
                                  (_controller.text),
                                )
                                    .then(
                                  (value) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    if (value == false) {
                                      StatusAlert.show(
                                        context,
                                        title: "Verified",
                                        titleOptions:
                                            StatusAlertTextConfiguration(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp + 1,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        maxWidth: 50.vw,
                                        configuration: IconConfiguration(
                                          icon: Icons.check,
                                          color: Colors.green,
                                          size: 50.w,
                                        ),
                                      );
                                      // Navigator.pop(context);
                                      Navigator.popAndPushNamed(
                                        context,
                                        "/onboarding",
                                      );
                                    } else {
                                      CustomDialog.show(context,
                                          message:
                                              "You already have an account with us. Please login",
                                          alertStyle: AlertStyle.error);
                                      setState(() {
                                        response = "User already exists";
                                      });
                                    }
                                  },
                                );
                              } catch (e) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                CustomDialog.show(context,
                                    message:
                                        "An error occured while performing your request",
                                    alertStyle: AlertStyle.error);
                                setState(() {
                                  response =
                                      "An error occured. Please try again";
                                });
                                // Navigator.pop(context);
                              }
                            } else {
                              Navigator.of(context, rootNavigator: true).pop();
                              CustomDialog.show(context,
                                  message:
                                      "Sorry, we couldn't verify your identity",
                                  alertStyle: AlertStyle.error);
                              setState(() {
                                response =
                                    "Sorry, we couldn't verify your identity";
                              });
                              // Navigator.pop(context);
                            }
                          },
                        );
                      } catch (e) {
                        Navigator.of(context, rootNavigator: true).pop();

                        CustomDialog.show(context,
                            message:
                                "An error occured while performing your request",
                            alertStyle: AlertStyle.error);
                        setState(() {
                          response = "An error occured. Please try again";
                        });
                      }
                    },
                    child: Text(
                      "verify",
                      style: TextStyle(fontSize: 16.sp + 1),
                    ),
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
  // String response = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text("Verify", style: TextStyle(fontSize: 18.sp + 1)),
          toolbarHeight: 48.w,
          leading: IconButton(
            icon: const BackButtonIcon(),
            iconSize: 24.sp,
            onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
          ),
        ),
        body: Container(
          color: cSec.withOpacity(0.1),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.all(30.0.w),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.lock, size: 24.sp, color: cSec),
                    SizedBox(height: 20.w),
                    Text(
                      "Please verify that you are a member of INFOCTESS-UEW",
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16.sp + 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.w),
                    Form(
                      key: _formKey,
                      child: InputControl(
                        hintText: "Index Number",
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
                    //     ? SizedBox(height: 10.w)
                    //     : const SizedBox.shrink(),
                    // response != ""
                    //     ? Text(
                    //         "$response ",
                    //         style:
                    //             TextStyle(color: Colors.red, fontSize: 12.sp + 1),
                    //       )
                    //     : const SizedBox.shrink(),
                    SizedBox(height: 40.w),
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
                        // setState(() {
                        //   response = "";
                        // });
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
                              switch (value) {
                                case 1:
                                  StatusAlert.show(
                                    context,
                                    title: "Verified",
                                    titleOptions: StatusAlertTextConfiguration(
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

                                  break;

                                case 2:
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  CustomDialog.show(context,
                                      message:
                                          "You have already registered. Please login",
                                      alertStyle: AlertStyle.error);

                                  break;

                                case 0:
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  CustomDialog.show(context,
                                      message:
                                          "We couldn't find your details. Please try again",
                                      alertStyle: AlertStyle.error);

                                  break;

                                default:
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();

                                  CustomDialog.show(context,
                                      message:
                                          "An error occured while performing your request",
                                      alertStyle: AlertStyle.error);
                                  break;
                              }
                            },
                          );
                        } catch (e) {
                          Navigator.of(context, rootNavigator: true).pop();

                          CustomDialog.show(context,
                              message:
                                  "An error occured while performing your request",
                              alertStyle: AlertStyle.error);
                          // setState(() {
                          //   response = "An error occured. Please try again";
                          // });
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
      ),
    );
  }
}

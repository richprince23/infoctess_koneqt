import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/user_state.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  TextEditingController nameCon = TextEditingController();
  var emailCon = TextEditingController();
  var passCon = TextEditingController();
  final basicFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameCon.dispose();
    emailCon.dispose();
    passCon.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameCon.text = onboardUser?.fullName ?? "";
    emailCon.text = onboardUser?.emailAddress ?? "";
  }

  void saveBasicInfo() {
    if (basicFormKey.currentState!.validate()) {
      onboardUser!.fullName = nameCon.text;
      onboardUser!.emailAddress = emailCon.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      // dismissOnCapturedTaps: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cPri,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/login");
            },
            icon: const BackButtonIcon(),
            iconSize: 24.w,
            color: Colors.white,
          ),
          title: Text(
            "Basic Info",
            style: GoogleFonts.sarabun(
                fontSize: 24.w,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
            child: Form(
              key: basicFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputControl(
                    hintText: "Fullname",
                    controller: nameCon,
                    validator: ((value) {
                      if (value!.isEmpty || value.length < 5) {
                        return "Enter a fullname";
                      }
                      return null;
                    }),
                  ),
                  InputControl(
                    hintText: "Email Address",
                    controller: emailCon,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'\S+@\S+\.\S+', caseSensitive: false)
                              .hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  InputControl(
                    hintText: "Password",
                    controller: passCon,
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return "Password must be 8 or more characters";
                      }
                      return null;
                    },
                  ),
                  InputControl(
                    hintText: "Confirm Password",
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty || value != passCon.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: btnLarge(context),
                        backgroundColor: cPri,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          if (basicFormKey.currentState!.validate()) {
                            // print("signing up");
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => Center(
                                child: Image.asset(
                                  "assets/images/preload.gif",
                                  height: 30.w,
                                  width: 30.w,
                                ),
                              ),
                            );
                            await Auth()
                                .signUp(emailCon.text.trim(), passCon.text)
                                .then((value) {
                              Auth().updateName(nameCon.text.trim());
                              Provider.of<UserState>(context, listen: false)
                                  .getUser(context);
                            }).then((value) {
                              Provider.of<OnboardingController>(context,
                                      listen: false)
                                  .nextPage();
                            });
                          } else {
                            CustomDialog.show(context,
                                message: "Please fill all fields");
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            CustomDialog.show(context,
                                message: "The password provided is too weak");
                          } else if (e.code == 'email-already-in-use') {
                            CustomDialog.show(context,
                                message:
                                    "The account already exists for that email");
                          } else {
                            CustomDialog.show(context,
                                message: "An error occured");
                          }
                        } finally {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "next",
                        style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                            fontSize: 18.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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

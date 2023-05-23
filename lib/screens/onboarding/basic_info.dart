import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
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
  final scrollController = ScrollController();

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
    nameCon.text = onboardUser!.fullName!;
    emailCon.text = onboardUser!.emailAddress!;
  }

  void saveBasicInfo() {
    if (basicFormKey.currentState!.validate()) {
      onboardUser!.fullName = nameCon.text;
      onboardUser!.emailAddress = emailCon.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: cPri,
              elevation: 0,
              pinned: true,
              toolbarHeight: 48.h,
              leading: IconButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/login");
                },
                icon: const BackButtonIcon(),
                iconSize: 24.h,
                color: Colors.white,
              ),
              expandedHeight: 160.h,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: true,
                title: Text(
                  "Basic Info",
                  style: GoogleFonts.sarabun(
                      fontSize: 24.h,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
                background: Container(
                  color: cPri,
                  child: Icon(
                    Icons.account_circle,
                    size: 80.h,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: SizedBox(
                height: 70.vh,
                width: 100.vw,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.h, vertical: 20.h),
                  child: Form(
                    key: basicFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            height: 10.h,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: btnLarge(context),
                                backgroundColor:
                                    AppTheme.themeData(false, context)
                                        .backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                // print(context.read<OnboardingController>().selectedLevel);
                                // print(context.read<OnboardingController>().selectedGroup);
                                // print(context.read<OnboardingController>().selectedGender);
                                try {
                                  if (!basicFormKey.currentState!.validate()) {
                                    return;
                                  }
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
                                  await Auth()
                                      .signUp(
                                          emailCon.text.trim(), passCon.text)
                                      .then((value) {
                                    Auth().updateName(nameCon.text.trim());
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .setUserID(value!.uid);
                                  }).then((value) {
                                    Provider.of<OnboardingController>(context,
                                            listen: false)
                                        .nextPage();
                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    CustomDialog.show(context,
                                        message:
                                            "The password provided is too weak");
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
                                    fontSize: 18.h,
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
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

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
    return Stack(
      children: [
        Positioned(
          top: 0,
          width: size.width,
          height: size.height * 0.45,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: size.width,
            color: AppTheme.themeData(false, context).backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    // size: 24,
                    color: Colors.white,
                  ),
                  iconSize: 24,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.white,
                      ),
                      Text(
                        "Basic Info",
                        style: GoogleFonts.sarabun(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(),
              ],
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.275,
          height: size.height * 0.7,
          width: size.width,
          child: Material(
            elevation: 6,
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: basicFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: SizedBox(
                          height: 500,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                                      !RegExp(r'\S+@\S+\.\S+',
                                              caseSensitive: false)
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size(size.width, 50),
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                );
                                await Auth()
                                    .signUp(emailCon.text.trim(), passCon.text)
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
                                  Platform.isAndroid
                                      ? showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const CustomDialog(
                                            message:
                                                "The password provided is too weak",
                                          ),
                                        )
                                      : showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              const CustomDialog(
                                            message:
                                                "The password provided is too weak",
                                          ),
                                        );
                                } else if (e.code == 'email-already-in-use') {
                                  Platform.isAndroid
                                      ? showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const CustomDialog(
                                            message:
                                                "The account already exists for that email",
                                          ),
                                        )
                                      : showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              const CustomDialog(
                                            message:
                                                "The account already exists for that email",
                                          ),
                                        );
                                }
                              } finally {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "next",
                              style: GoogleFonts.sarabun(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

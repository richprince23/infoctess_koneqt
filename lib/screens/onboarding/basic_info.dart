import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

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
          top: size.height * 0.30,
          height: size.height * 0.65,
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
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        width: size.width,
                        child: Builder(builder: (context) {
                          return TextButton(
                            style: TextButton.styleFrom(
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
                              } catch (e) {
                                Platform.isAndroid
                                    ? showDialog(
                                        useRootNavigator: true,
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          elevation: 10,
                                          title: const Text('Error'),
                                          content: Text(e.toString()),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : CupertinoAlertDialog(
                                        title: const Text('Error'),
                                        content: Text(e.toString()),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          ),
                                        ],
                                      );
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
                          );
                        }),
                      ),
                    )
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

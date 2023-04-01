import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/screens/home/homepage.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';

import 'package:infoctess_koneqt/screens/onboarding.dart';
import 'package:infoctess_koneqt/screens/onboarding/check_index.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          height: size.height * 0.6,
          child: Container(
            width: size.width,
            color: AppTheme.themeData(false, context).backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    width: size.width * 0.3,
                    height: size.width * 0.3,
                    image:
                        const AssetImage("assets/images/infoctess_logo_bg.png"),
                  ),
                  Text(
                    "Infoctess Koneqt",
                    style: GoogleFonts.sarabun(
                        fontSize: 34,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Login",
                    style: GoogleFonts.sarabun(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          height: MediaQuery.of(context).size.height * 0.45,
          // height: 200,
          // top: 100,
          bottom: 0,
          child: Material(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputControl(
                      hintText: "Email Address",
                      type: TextInputType.emailAddress,
                      controller: _email,
                      isPassword: false,
                    ),
                    InputControl(
                      hintText: "Password",
                      type: TextInputType.text,
                      controller: _pass,
                      isPassword: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        try {
                          await Auth()
                              .signIn(_email.text.trim(), _pass.text)
                              .then((user) async => {
                                    if (user != null)
                                      {
                                        // save user to shared prefs
                                        Provider.of<UserProvider>(context)
                                            .setUserID(user.uid),
                                        Provider.of<UserProvider>(context)
                                            .setLoggedIn(true),
                                        await Navigator.pushReplacementNamed(
                                            context, "/")
                                      }
                                  });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'network-request-failed') {
                            Platform.isAndroid
                                ? showDialog(
                                    context: context,
                                    builder: (context) => const CustomDialog(
                                        message: "No Internet Connection"))
                                : showCupertinoDialog(
                                    context: context,
                                    builder: (context) => const CustomDialog(
                                      message: "No Internet Connection",
                                    ),
                                  );
                            //devtools.log('No Internet Connection');
                          } else if (e.code == "wrong-password") {
                            Platform.isAndroid
                                ? showDialog(
                                    context: context,
                                    builder: (context) => const CustomDialog(
                                        message:
                                            'Please Enter correct password'))
                                : showCupertinoDialog(
                                    context: context,
                                    builder: (context) => const CustomDialog(
                                        message:
                                            'Please Enter correct password'));

                            //devtools.log('Please Enter correct password');
                            //print('Please Enter correct password');
                          } else if (e.code == 'user-not-found') {
                            Platform.isAndroid
                                ? showDialog(
                                    context: context,
                                    builder: (context) => const CustomDialog(
                                        message: 'Email not found'))
                                : showCupertinoDialog(
                                    context: context,
                                    builder: (context) => const CustomDialog(
                                        message: 'Email not found'));

                            // print('Email not found');
                          } else if (e.code == 'too-many-requests') {
                            Platform.isAndroid
                                ? showDialog(
                                    context: context,
                                    builder: (context) => const CustomDialog(
                                        message: "Too many attemps; try later"))
                                : showCupertinoDialog(
                                    context: context,
                                    builder: (context) => const CustomDialog(
                                        message:
                                            'Too many attemps; try later'));

                            //print('Too many attempts please try later');
                          } else {
                            Platform.isAndroid
                                ? showDialog(
                                    context: context,
                                    builder: (context) =>
                                        CustomDialog(message: e.message!))
                                : showCupertinoDialog(
                                    context: context,
                                    builder: (context) =>
                                        CustomDialog(message: e.message!));
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(74, 19, 193, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: Size(size.width, 50),
                      ),
                      child: const Text(
                        "login",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    // const OnboardingScreen(),
                                    const CheckAccessPage(),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: Size(size.width, 50),
                              side: BorderSide(
                                color: AppTheme.themeData(false, context)
                                    .backgroundColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "create cccount",
                              style: GoogleFonts.sarabun(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.themeData(false, context)
                                      .backgroundColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            //TODO: Change this to reset password, this is just for testing
                            onTap: (() => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                )),

                            child: Text(
                              "reset password",
                              style: GoogleFonts.sarabun(
                                textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    color: AppTheme.themeData(false, context)
                                        .focusColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ),
          ),
        ),
      ],
    );
  }
}

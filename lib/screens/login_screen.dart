import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/screens/forgot_password.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: 100.vh,
          width: 100.vw,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                height: 40.vh,
                child: Container(
                  width: size.width,
                  color: cPri,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: SizedBox(
                          height: sh4(context) - 10,
                        ),
                      ),
                      Image(
                        width: 30.vw,
                        height: 30.vw,
                        image: const AssetImage(
                            "assets/images/infoctess_logo_bg.png"),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "INFOCTESS KONEQT",
                        style: GoogleFonts.sarabun(
                            fontSize: 24.sp + 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Welcome Back",
                        style: GoogleFonts.sarabun(
                            fontSize: 20.sp + 1,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                height: 65.vh,
                // height: 200,
                // top: size.height * 0.35,
                bottom: 0,
                child: Material(
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
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
                              validator: (value) {
                                if (value!.isEmpty &&
                                    !RegExp(r'\S+@\S+\.\S+',
                                            caseSensitive: false)
                                        .hasMatch(value)) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              }),
                          InputControl(
                            hintText: "Password",
                            type: TextInputType.text,
                            controller: _pass,
                            isPassword: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a valid password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          GestureDetector(
                            //TODO: Implement Forgot Password
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            ),

                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "forgot password",
                                style: GoogleFonts.sarabun(
                                  textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14.sp + 1,
                                    color: AppTheme.themeData(false, context)
                                        .focusColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => Center(
                                  child: Image.asset(
                                    "assets/images/preload.gif",
                                    height: size.width * 0.1,
                                    width: size.width * 0.1,
                                  ),
                                ),
                              );
                              try {
                                await Auth()
                                    .signIn(_email.text.trim(), _pass.text)
                                    .then((user) async => {
                                          if (user != null)
                                            {
                                              await Provider.of<UserProvider>(
                                                      context,
                                                      listen: false)
                                                  .setUserID(user.uid)
                                                  .then(
                                                    (value) => {
                                                      Provider.of<UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .setUserDetails(),

                                                      // save user to shared prefs
                                                      Provider.of<UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .setLoggedIn(true),
                                                    },
                                                  )
                                                  .then((value) => Navigator
                                                      .pushReplacementNamed(
                                                          context, "/"))
                                            }
                                        });
                              } on FirebaseAuthException catch (e) {
                                Navigator.pop(context);
                                if (e.code == 'network-request-failed') {
                                  CustomDialog.show(context,
                                      message:
                                          "No Internet Connection"); //devtools.log('No Internet Connection');
                                } else if (e.code == "wrong-password") {
                                  CustomDialog.show(context,
                                      message: "Please enter correct password");

                                  //devtools.log('Please Enter correct password');
                                  //print('Please Enter correct password');
                                } else if (e.code == 'user-not-found') {
                                  CustomDialog.show(context,
                                      message: "No user found for this email");

                                  // print('Email not found');
                                } else if (e.code == 'too-many-requests') {
                                  CustomDialog.show(context,
                                      message: "Too many attemps; try later");

                                  //print('Too many attempts please try later');
                                } else {
                                  CustomDialog.show(context,
                                      message:
                                          "Something went wrong. Try again");

                                  //print('Something went wrong');
                                }
                              }
                              // finally {
                              //   Navigator.pop(context);
                              // }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: cPri,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              minimumSize: btnLarge(context),
                            ),
                            child: Text(
                              "login",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp + 1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, "/checker"),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Don't have an account? Sign up",
                                style: GoogleFonts.sarabun(
                                  textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16.sp + 1,
                                    color: AppTheme.themeData(false, context)
                                        .focusColor,
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
            ],
          ),
        ),
      ),
    );
  }
}

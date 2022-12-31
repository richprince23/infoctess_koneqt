import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:infoctess_koneqt/screens/onboarding.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  final _formKey = GlobalKey<FormState>();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          height: size.height * 0.4,
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
                    "Welcome!",
                    style: GoogleFonts.sarabun(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none),
                  ),
                  Text(
                    "Login to continue",
                    style: GoogleFonts.sarabun(
                        fontSize: 16,
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
          height: MediaQuery.of(context).size.height * 0.65,
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
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 50,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(74, 19, 193, 1)),
                      width: size.width,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                        },
                        child: const Text(
                          "login",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (() => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                )),
                            child: Text(
                              "Reset Password",
                              style: GoogleFonts.sarabun(
                                  textStyle: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      color: AppTheme.themeData(false, context)
                                          .focusColor)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: (() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OnboardingScreen(),
                                  ),
                                )),
                            child: Text(
                              "Create Account",
                              style: GoogleFonts.sarabun(
                                textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    color: AppTheme.themeData(false, context)
                                        .backgroundColor),
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

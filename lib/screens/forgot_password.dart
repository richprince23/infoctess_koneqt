import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final textController = TextEditingController(text: curUser?.emailAddress);
  String response = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        centerTitle: true,
      ),
      // backgroundColor: Colors.white.withOpacity(0.9),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                ),
                child: EmptyList(
                  text:
                      "Please enter your email address below to recieve a link to reset your password",
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              InputControl(
                controller: textController,
                hintText: "Email Address",
                showLabel: false,
                type: TextInputType.emailAddress,
              ),
              SizedBox(
                height: response == "" ? 0 : 10.h,
              ),
              response != ""
                  ? Text(
                      "$response ",
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    )
                  : const SizedBox.shrink(),
              SizedBox(
                height: 5.h,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text == "" ||
                      !RegExp(r'\S+@\S+\.\S+', caseSensitive: false)
                          .hasMatch(textController.text.trim())) {
                    setState(() {
                      response = "Please enter a valid password";
                    });
                    return;
                  }
                  setState(() {
                    response = "";
                  });
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => Center(
                      child: Image.asset(
                        "assets/images/preload.gif",
                        width: 50.w,
                        height: 50.w,
                      ),
                    ),
                  );
                  try {
                    await auth.sendPasswordResetEmail(
                        email: textController.text);
                    setState(() {
                      response =
                          "Password reset email has been sent to your email!";
                    });
                  } catch (e) {
                    Navigator.pop(context);
                    response = "An error occured. Try again";
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: btnLarge(context),
                  backgroundColor: cPri,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

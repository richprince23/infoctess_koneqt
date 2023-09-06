import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
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
                padding: EdgeInsets.all(20.w),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/no_access.png",
                      width: 100.w,
                    ),
                    Text(
                      "Please enter your email address below to recieve a link to reset your password",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.w,
              ),
              InputControl(
                controller: textController,
                hintText: "Email Address",
                showLabel: false,
                type: TextInputType.emailAddress,
              ),
              SizedBox(
                height: response == "" ? 0 : 20.w,
              ),
              response != ""
                  ? Text(
                      "$response ",
                      style: TextStyle(
                          color: response.contains("sent")
                              ? Colors.green
                              : Colors.red,
                          fontSize: 16.sp + 1),
                    )
                  : const SizedBox.shrink(),
              SizedBox(
                height: 10.w,
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
                        width: 30.w,
                        height: 30.w,
                      ),
                    ),
                  );
                  try {
                    await auth.sendPasswordResetEmail(
                        email: textController.text.trim());
                    setState(() {
                      response =
                          "Password reset email has been sent to your email!";
                    });
                  } catch (e) {
                    response = e.toString().split("]")[1];
                  } finally {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: btnLarge(context),
                  backgroundColor: cPri,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                child: const Text("reset password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

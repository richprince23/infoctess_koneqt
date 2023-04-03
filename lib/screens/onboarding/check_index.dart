import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/screens/onboarding.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:status_alert/status_alert.dart';
import 'package:infoctess_koneqt/auth.dart';

class CheckAccessPage extends StatefulWidget {
  const CheckAccessPage({super.key});

  @override
  State<CheckAccessPage> createState() => _CheckAccessPageState();
}

class _CheckAccessPageState extends State<CheckAccessPage> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String response = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 40),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    alignment: Alignment.centerLeft,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      "Verify",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock, size: 100, color: Colors.red),
                  Text(
                    "This app is limited to members of INFOCTESS only. \nTo enforce this, you are required to verify your membership with your Index Number.",
                    softWrap: true,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: InputControl(
                        hintText: "Enter your Index Number",
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
                    const SizedBox(height: 10),
                    Text(
                      "$response ",
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(200, 50),
                          backgroundColor: AppTheme.themeData(false, context)
                              .backgroundColor,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 18)),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          response = "";
                        });
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
                        try {
                          await checkUserAccess((_controller.text)).then(
                            (value) async {
                              if (value != null) {
                                // Navigator.pop(context);
                                print("value of first check: $value");
                                try {
                                  await Auth()
                                      .checkUserExists(
                                    int.parse(_controller.text),
                                  )
                                      .then(
                                    (value) {
                                      print("checking user exists: $value");
                                      Navigator.pop(context);
                                      if (value == false) {
                                        StatusAlert.show(
                                          context,
                                          title: "Verified",
                                          configuration:
                                              const IconConfiguration(
                                            icon: Icons.done,
                                          ),
                                        );
                                        Navigator.pop(context);
                                        Navigator.popAndPushNamed(
                                          context,
                                          "/onboarding",
                                        );
                                      } else {
                                        setState(() {
                                          response = "User already exists";
                                        });
                                      }
                                    },
                                  );
                                } catch (e) {
                                  Platform.isAndroid
                                      ? showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const CustomDialog(
                                            message:
                                                "An error occurred while performing your request",
                                          ),
                                        )
                                      : showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              const CustomDialog(
                                            message:
                                                "An error occured while performing your request",
                                          ),
                                        );
                                  setState(() {
                                    response =
                                        "An error occured. Please try again";
                                  });
                                  Navigator.pop(context);
                                }
                                setState(() {
                                  response = "";
                                });
                              } else {
                                setState(() {
                                  response =
                                      "Member not found. Please ensure you have registered with Infoctess.If you have, contact the admin to reslove this.";
                                });
                                Navigator.pop(context);
                              }
                            },
                          );
                        } catch (e) {
                          Platform.isAndroid
                              ? showDialog(
                                  context: context,
                                  builder: (context) => const CustomDialog(
                                    message:
                                        "An error occurred while performing your request",
                                  ),
                                )
                              : showCupertinoDialog(
                                  context: context,
                                  builder: (context) => const CustomDialog(
                                    message:
                                        "An error occured while performing your request",
                                  ),
                                );
                          setState(() {
                            response = "An error occured. Please try again";
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Verify"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

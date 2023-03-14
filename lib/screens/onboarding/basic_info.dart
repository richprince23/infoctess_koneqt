import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  GlobalKey formKey = GlobalKey<FormState>();

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Center(
                  // padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Basic Info",
                    style: GoogleFonts.sarabun(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none),
                  ),
                ),
                const SizedBox(),
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
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InputControl(
                        hintText: "Fullname",
                      ),
                      InputControl(
                        hintText: "Email Address",
                      ),
                      InputControl(
                        hintText: "Password",
                      ),
                      InputControl(
                        hintText: "Confirm Password",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/components/select_control1.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:provider/provider.dart';

class AcademicInfoScreen extends StatefulWidget {
  AcademicInfoScreen({super.key});

  @override
  State<AcademicInfoScreen> createState() => _AcademicInfoScreenState();
}

class _AcademicInfoScreenState extends State<AcademicInfoScreen> {
  final List<String> levels = [
    'Level 100',
    'Level 200',
    'Level 300',
    'Level 400',
  ];

  final List<String> classgroup = [
    'Group 1',
    'Group 2',
    'Group 3',
    'Group 4',
    'Group 5',
    'Group 6',
    'Group 7',
    'Group 8',
    'Group 9',
    'Group 10',
  ];
  final List<String> gender = ['Male', 'Female'];
  final ScrollController _scrollController = ScrollController();
  // GlobalKey formKey = GlobalKey<FormState>();
  final indexNumCon = TextEditingController();

  @override
  void initState() {
    indexNumCon.text = onboardUser!.indexNum!.toString();
    super.initState();
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
                    setState(() {
                      //           // goBack();
                      Provider.of<OnboardingController>(context, listen: false)
                          .goBack();
                    });
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
                        Icons.school,
                        size: 100,
                        color: Colors.white,
                      ),
                      Text(
                        "Academic Info",
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
            elevation: 5,
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: acadFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            InputControl(
                              hintText: "Index Number",
                              controller: indexNumCon,
                              readOnly: true,
                            ),
                            SelectControl(
                              hintText: "Study Level",
                              onChanged: (levelVal) => setState(() {
                                Provider.of<OnboardingController>(context,
                                        listen: false)
                                    .selectedLevel = levelVal!;
                              }),
                              items: levels
                                  .map(
                                    (String levelVal) =>
                                        DropdownMenuItem<String>(
                                      value: levelVal,
                                      child: Text(levelVal),
                                    ),
                                  )
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a level";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SelectControl(
                              hintText: "Class Group",
                              onChanged: (groupVal) => setState(() {
                                Provider.of<OnboardingController>(context,
                                        listen: false)
                                    .selectedGroup = groupVal!;
                              }),
                              items: classgroup
                                  .map(
                                    (String groupVal) =>
                                        DropdownMenuItem<String>(
                                      value: groupVal,
                                      child: Text(groupVal),
                                    ),
                                  )
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a class group";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SelectControl(
                              hintText: "Gender",
                              onChanged: (genderVal) => setState(() {
                                Provider.of<OnboardingController>(context,
                                        listen: false)
                                    .selectedGender = genderVal!;
                              }),
                              items: gender
                                  .map(
                                    (String genderVal) =>
                                        DropdownMenuItem<String>(
                                      value: genderVal,
                                      child: Text(genderVal),
                                    ),
                                  )
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a gender";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
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
                                if (!acadFormKey.currentState!.validate()) {
                                  return;
                                }
                                // Provider.of<OnboardingController>(context,
                                //         listen: false)
                                //     .indexNum = indexNumCon.text;
                                onboardUser!.userLevel = context
                                    .read<OnboardingController>()
                                    .selectedLevel;
                                onboardUser!.classGroup = context
                                    .read<OnboardingController>()
                                    .selectedGroup;
                                onboardUser!.gender = context
                                    .read<OnboardingController>()
                                    .selectedGender;
                              } catch (e) {
                                Platform.isAndroid
                                    ? showDialog(
                                        useRootNavigator: true,
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => AlertDialog(
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
                              Provider.of<OnboardingController>(context,
                                      listen: false)
                                  .nextPage();
                            },
                            child: Text(
                              "next",
                              style: GoogleFonts.sarabun(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    color: Colors.white),
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

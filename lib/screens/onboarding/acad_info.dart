import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/components/select_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

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

    return KeyboardDismissOnTap(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: cPri,
              pinned: true,
              toolbarHeight: 48.h,
              leading: IconButton(
                onPressed: () {
                  Provider.of<OnboardingController>(context, listen: false)
                      .goBack();
                },
                icon: const BackButtonIcon(),
                color: Colors.white,
                iconSize: 24.h,
              ),
              expandedHeight: 160.h,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: true,
                title: Text(
                  "Academic Info",
                  style: GoogleFonts.sarabun(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
                background: Container(
                  color: cPri,
                  child: Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 80.h,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: SizedBox(
                height: 100.vh,
                width: 100.vw,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.h, vertical: 20.h),
                  child: Form(
                    key: acadFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                  (String levelVal) => DropdownMenuItem<String>(
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
                                  (String groupVal) => DropdownMenuItem<String>(
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
                          SizedBox(
                            height: 10.h,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: btnLarge(context),
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
                                  CustomDialog.show(context,
                                      message: "Please fill all fields");
                                }
                                Provider.of<OnboardingController>(context,
                                        listen: false)
                                    .nextPage();
                              },
                              child: Text(
                                "next",
                                style: GoogleFonts.sarabun(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none,
                                    fontSize: 18.sp + 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/components/select_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class AcademicInfoScreen extends StatefulWidget {
  const AcademicInfoScreen({super.key});

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
  final acadFormKey = GlobalKey<FormState>();
  final indexNumCon = TextEditingController();

  @override
  void initState() {
    indexNumCon.text = onboardUser!.indexNum!.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cPri,
          title: Text(
            "Academic Info",
            style: GoogleFonts.sarabun(
              fontSize: 24.sp,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Provider.of<OnboardingController>(context, listen: false)
                  .goBack();
            },
            icon: const BackButtonIcon(),
            iconSize: 24.w,
            color: Colors.white,
          ),
        ),
        body: Form(
          key: acadFormKey,
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
            children: [
              InputControl(
                hintText: "Index Number",
                controller: indexNumCon,
                readOnly: true,
              ),
              SelectControl(
                hintText: "Study Level",
                onChanged: (levelVal) => setState(() {
                  Provider.of<OnboardingController>(context, listen: false)
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
                  Provider.of<OnboardingController>(context, listen: false)
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
                  Provider.of<OnboardingController>(context, listen: false)
                      .selectedGender = genderVal!;
                }),
                items: gender
                    .map(
                      (String genderVal) => DropdownMenuItem<String>(
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
                height: 10.w,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: btnLarge(context),
                    backgroundColor: cPri,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      if (acadFormKey.currentState!.validate()) {
                        print(onboardUser?.toJson());
                        onboardUser?.userLevel =
                            context.read<OnboardingController>().selectedLevel;
                        onboardUser?.classGroup =
                            context.read<OnboardingController>().selectedGroup;
                        onboardUser?.gender =
                            context.read<OnboardingController>().selectedGender;
                        Provider.of<OnboardingController>(context,
                                listen: false)
                            .nextPage();
                      }
                      // else {
                      //   CustomDialog.show(
                      //     context,
                      //     message: "Please fill all fields",
                      //   );
                      // }
                    } catch (e) {
                      // CustomDialog.show(
                      //   context,
                      //   message: "An error occured. Please try again later.",
                      //   // message: e.toString(),
                      // );
                    }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

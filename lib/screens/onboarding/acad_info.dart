import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/components/select_control1.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/screens/onboarding.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:provider/provider.dart';

class AcademicInfoScreen extends StatefulWidget {
  AcademicInfoScreen({super.key});

  @override
  State<AcademicInfoScreen> createState() => _AcademicInfoScreenState();
}

class _AcademicInfoScreenState extends State<AcademicInfoScreen> {
  final List<String> levels = [
    '100',
    '200',
    '300',
    '400',
    // '500',
    // '600',
    // '700',
    // '800',
    // '900'
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
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          top: 0,
          width: size.width,
          height: size.height * 0.20,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: size.width,
            color: AppTheme.themeData(false, context).backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        // goBack();
                        Provider.of<OnboardingController>(context,
                                listen: false)
                            .goBack();
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "2. Academic Info",
                    style: GoogleFonts.sarabun(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.10,
          height: size.height * 0.85,
          width: size.width,
          child: Material(
            elevation: 5,
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InputControl(
                        hintText: "Index Number",
                        controller: TextEditingController(text: "202112200"),
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
                              (String genderVal) => DropdownMenuItem<String>(
                                value: genderVal,
                                child: Text(genderVal),
                              ),
                            )
                            .toList(),
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

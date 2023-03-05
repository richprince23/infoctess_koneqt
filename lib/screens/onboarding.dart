import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/screens/main_screen.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/widgets/indicator.dart';
import 'package:provider/provider.dart';

// int curPageIndex = 0;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String buttonText = "next";
  @override
  void initState() {
    super.initState();
    buttonText = "next";
  }

  @override
  Widget build(BuildContext context) {
    // int curPageIndex = pageController.initialPage
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          padEnds: true,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          itemCount: kPages.length,
          itemBuilder: (context, index) {
            return Consumer<OnboardingController>(
              builder: ((context, value, child) {
                return kPages[value.curPageIndex];
              }),
            );
          },
          pageSnapping: true,
          onPageChanged: (value) {
            Provider.of<OnboardingController>(context, listen: false)
                .curPageIndex = value;
            setState(() {
              if (value == kPages.length - 1) {
                buttonText = "finish";

                //todo
                //some validations and savings

              } else {
                buttonText = "next";
                //todo
                //validations and savings

              }
            });
          },
        ),
      ),
      persistentFooterButtons: [
        Column(
          mainAxisSize: MainAxisSize.max,
          key: const Key("column_key"),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              width: size.width,
              child: Builder(builder: (context) {
                return TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor:
                        AppTheme.themeData(false, context).backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    print(context.read<OnboardingController>().selectedLevel);
                    print(context.read<OnboardingController>().selectedGroup);
                    print(context.read<OnboardingController>().selectedGender);
                    setState(() {
                      Provider.of<OnboardingController>(context, listen: false)
                          .nextPage();
                    });
                    if (pageController.page == kPages.length - 1) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: Text(
                    buttonText,
                    style: GoogleFonts.sarabun(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                            fontSize: 20,
                            color: Colors.white)),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 5,
            ),
            Consumer<OnboardingController>(builder: ((context, value, child) {
              return Indicator(
                  count: kPages.length, curIndex: value.curPageIndex);
            })),
          ],
        ),
      ],
    );
  }
}

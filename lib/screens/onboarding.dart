import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/env.dart';
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
    return Scaffold(
      body: PageView.builder(
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
      persistentFooterButtons: [
        Column(
          mainAxisSize: MainAxisSize.max,
          key: const Key("column_key"),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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

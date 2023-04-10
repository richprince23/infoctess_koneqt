import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final ScrollController _scrollController = ScrollController();
  // GlobalKey formKey = GlobalKey<FormState>();
  ImagePicker imagePicker = ImagePicker();
  final userNameCon = TextEditingController();
  final phoneNumCon = TextEditingController();

  XFile? selectedMedia;
  CroppedFile? croppedMedia;

  Future<void> cropImage() async {
    if (selectedMedia != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedMedia!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 20,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Media',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: false,
            showCropGrid: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Media',
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          croppedMedia = croppedFile;
          // selectedMedia = croppedFile as XFile;
        });
      }
    }
  }

  Future<void> uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedMedia = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
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
              icon: const Icon(
                Icons.arrow_back,
              ),
              iconSize: 24.h,
              color: Colors.white,
            ),
            expandedHeight: 160.h,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              centerTitle: true,
              title: Text(
                "Profile Info",
                style: GoogleFonts.sarabun(
                    fontSize: 24.h,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none),
              ),
              background: Container(
                color: cPri,
                child: Icon(
                  Icons.person_pin,
                  color: Colors.white,
                  size: 80.h,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: SizedBox(
              height: 100.vh,
              width: size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 20.h),
                child: Form(
                  key: profileFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Choose Profile Image",
                          style: GoogleFonts.sarabun(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        selectedMedia != null
                            ? ClipOval(
                                child: Image.file(
                                  File(selectedMedia!.path),
                                  width: size.width * 0.35,
                                  height: size.width * 0.35,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor:
                                    AppTheme.themeData(false, context)
                                        .backgroundColor,
                                radius: (size.width * 0.35) / 2,
                                child: const Text(
                                  "User",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                        const SizedBox(height: 10),
                        TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5)),
                              backgroundColor: MaterialStateProperty.all(
                                  AppTheme.themeData(false, context)
                                      .indicatorColor)),
                          onPressed: () async {
                            await uploadImage().then((value) => cropImage());
                          },
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    )),
                                WidgetSpan(
                                  child: SizedBox(
                                    width: 10,
                                  ),
                                ),
                                TextSpan(
                                  text: "browse",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InputControl(
                          hintText: "Username",
                          type: TextInputType.name,
                          controller: userNameCon,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username cannot be empty";
                            }
                            return null;
                          },
                        ),
                        InputControl(
                          hintText: "Phone Number",
                          type: TextInputType.phone,
                          controller: phoneNumCon,
                          validator: (value) {
                            if (value!.length < 10) {
                              return "Phone Number must be 10 digits";
                            }
                            return null;
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: btnLarge(context),
                            backgroundColor: AppTheme.themeData(false, context)
                                .backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              if (!profileFormKey.currentState!.validate()) {
                                return;
                              }
                              setState(() {
                                onboardUser!.userName =
                                    userNameCon.text.trim().toLowerCase();
                                onboardUser!.phoneNum = phoneNumCon.text.trim();
                              });
                              if (croppedMedia != null) {
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
                                await Auth()
                                    .saveUserInfo(
                                      indexNum:
                                          onboardUser!.indexNum.toString(),
                                      userName: onboardUser!.userName,
                                      phoneNum: onboardUser!.phoneNum,
                                      gender: onboardUser!.gender,
                                      level: onboardUser!.userLevel,
                                      classGroup: onboardUser!.classGroup,
                                      fullName: onboardUser!.fullName,
                                    )
                                    .then((value) async => await Auth()
                                        .saveUserImage(croppedMedia!.path))
                                    .then((value) async => {
                                          StatusAlert.show(
                                            context,
                                            title: "Success",
                                            subtitle:
                                                "Your profile has been updated",
                                            configuration:
                                                const IconConfiguration(
                                                    icon: Icons
                                                        .check_circle_outline),
                                            duration:
                                                const Duration(seconds: 3),
                                          ),
                                          await setUserDetails(),
                                          Navigator.pushReplacementNamed(
                                              context, "/"),
                                        });
                              }
                            } catch (e) {
                              Platform.isAndroid
                                  ? showDialog(
                                      context: context,
                                      builder: (context) => const CustomDialog(
                                          message:
                                              "An error occurred while performing you request"),
                                    )
                                  : showCupertinoDialog(
                                      context: context,
                                      builder: (context) => const CustomDialog(
                                          message:
                                              "An error occurred while performing you request"),
                                    );
                            }
                            setState(() {
                              Provider.of<OnboardingController>(context,
                                      listen: false)
                                  .nextPage();
                            });
                          },
                          child: Text(
                            "finish",
                            style: GoogleFonts.sarabun(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                                fontSize: 20,
                                color: Colors.white,
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
    );
  }
}

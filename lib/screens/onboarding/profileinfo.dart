import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
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
                        Icons.person_pin,
                        size: 100,
                        color: Colors.white,
                      ),
                      Text(
                        "Profile Info",
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
          top: size.height * 0.275,
          height: size.height * 0.7,
          width: size.width,
          child: Material(
            elevation: 5,
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: profileFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
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
                                await uploadImage()
                                    .then((value) => cropImage());
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
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size(size.width, 50),
                          padding: const EdgeInsets.symmetric(vertical: 15),
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
                            if (selectedMedia != null) {
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
                                    indexNum: onboardUser!.indexNum.toString(),
                                    userName: onboardUser!.userName,
                                    phoneNum: onboardUser!.phoneNum,
                                    gender: onboardUser!.gender,
                                    level: onboardUser!.userLevel,
                                    classGroup: onboardUser!.classGroup,
                                  )
                                  .then((value) async => await Auth()
                                      .saveUserImage(selectedMedia!.path))
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
                                          duration: const Duration(seconds: 3),
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
                      ),
                    ))
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

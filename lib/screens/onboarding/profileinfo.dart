import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/controllers/user_state.dart';
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
  ImagePicker imagePicker = ImagePicker();
  final userNameCon = TextEditingController();
  final phoneNumCon = TextEditingController();
  final profileFormKey = GlobalKey<FormState>();

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
  initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   Provider.of<OnboardingController>(context, listen: false).nextPage();
    // });
  }

  @override
  dispose() {
    super.dispose();
    userNameCon.dispose();
    phoneNumCon.dispose();
    selectedMedia = null;
    croppedMedia = null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: cPri,
        title: Text(
          "Profile Info",
          style: GoogleFonts.sarabun(
            fontSize: 24.w,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Provider.of<OnboardingController>(context, listen: false).goBack();
          },
          icon: const BackButtonIcon(),
          iconSize: 24.w,
          color: Colors.white,
        ),
        // pinned: true,
        // toolbarHeight: 48.w,
        // expandedHeight: 160.w,
      ),
      body: SizedBox(
        height: 100.vh,
        width: size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 0.w),
          child: Form(
            key: profileFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Choose Profile Image",
                    style: GoogleFonts.sarabun(fontSize: 16.sp),
                  ),
                  SizedBox(height: 10.h),
                  croppedMedia != null
                      ? ClipOval(
                          child: Image.file(
                            File(croppedMedia!.path),
                            width: size.width * 0.35,
                            height: size.width * 0.35,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: cPri,
                          radius: (size.width * 0.35) / 2,
                          child: const Text(
                            "User",
                            textAlign: TextAlign.center,
                          ),
                        ),
                  SizedBox(height: 10.h),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          AppTheme.themeData(false, context).indicatorColor),
                    ),
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
                            ),
                          ),
                          WidgetSpan(
                            child: SizedBox(
                              width: 10,
                            ),
                          ),
                          TextSpan(
                            text: "browse",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
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
                      if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]+$')
                              .hasMatch(value!) &&
                          value.length < 4) {
                        return "Username can only contain letters, numbers and underscore ";
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
                  SizedBox(
                    height: 20.w,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: btnLarge(context),
                      backgroundColor: cPri,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: ((croppedMedia != null) &&
                                onboardUser!.userName != "" &&
                                onboardUser!.phoneNum != "") ==
                            true
                        ? () async {
                            try {
                              if (profileFormKey.currentState!.validate()) {
                                setState(() {
                                  onboardUser!.userName =
                                      userNameCon.text.trim().toLowerCase();
                                  onboardUser!.phoneNum =
                                      phoneNumCon.text.trim();
                                });
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => Center(
                                    // title: const Text("Verification"),
                                    child: Image.asset(
                                      "assets/images/preload.gif",
                                      height: 30.w,
                                      width: 30.w,
                                    ),
                                  ),
                                );
                                await Auth()
                                    .checkUserExists(
                                        onboardUser!.indexNum!.toString())
                                    .then((value) async => {
                                          if (value! == false)
                                            {
                                              await Auth()
                                                  .saveUserInfo(
                                                      indexNum: onboardUser!
                                                          .indexNum
                                                          .toString(),
                                                      userName:
                                                          onboardUser!.userName,
                                                      phoneNum:
                                                          onboardUser!.phoneNum,
                                                      gender:
                                                          onboardUser!.gender,
                                                      level: onboardUser!
                                                          .userLevel,
                                                      classGroup: onboardUser!
                                                          .classGroup,
                                                      fullName:
                                                          onboardUser!.fullName,
                                                      avatar:
                                                          croppedMedia!.path)
                                                  .then(
                                                    (value) async => {
                                                      await Provider.of<
                                                                  UserState>(
                                                              context,
                                                              listen: false)
                                                          .setCurUser(
                                                              onboardUser),
                                                      Navigator.pop(context),
                                                      StatusAlert.show(
                                                        context,
                                                        title: "Success",
                                                        subtitle:
                                                            "Your profile has been updated",
                                                        maxWidth: 50.vw,
                                                        titleOptions:
                                                            StatusAlertTextConfiguration(
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.sp + 1,
                                                          ),
                                                        ),
                                                        configuration:
                                                            IconConfiguration(
                                                          icon: Icons.check,
                                                          color: Colors.green,
                                                          size: 50.w,
                                                        ),
                                                      ),
                                                      setState(() {
                                                        Provider.of<OnboardingController>(
                                                                context,
                                                                listen: false)
                                                            .nextPage();
                                                      }),
                                                      await Navigator
                                                          .pushNamedAndRemoveUntil(
                                                        context,
                                                        "/",
                                                        (route) => false,
                                                      ),
                                                    },
                                                  ),
                                            }
                                        });
                              }
                            } catch (e) {
                              CustomDialog.show(context,
                                  message:
                                      "An error occurred while performing your request");
                            }
                          }
                        : () {
                            CustomDialog.show(
                              context,
                              message: "Please choose a Profile picture!",
                            );
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
    );
  }
}

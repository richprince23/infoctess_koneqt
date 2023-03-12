import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/onboarding_controller.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:provider/provider.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final ScrollController _scrollController = ScrollController();
  GlobalKey formKey = GlobalKey<FormState>();
  ImagePicker imagePicker = ImagePicker();

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
          height: size.height * 0.20,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: size.width,
            color: AppTheme.themeData(false, context).backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      // goBack();
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
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "3. Profile Info",
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
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Material(
              elevation: 5,
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      ),
                      InputControl(
                        hintText: "Phone Number",
                        type: TextInputType.phone,
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

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  File? selectedImage;

  Future getImagefromGallery() async {
    try {
      final image = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 80);
      if (image == null) return;
      final tempImage = File(image.path);

      setState(() {
        selectedImage = tempImage;
      });
    } on PlatformException catch (e) {
      print('$e');
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
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                      CupertinoIcons.back,
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
                      selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                selectedImage!.absolute,
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
                          getImagefromGallery();
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

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/components/select_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/profile_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/models/user_info.dart';
import 'package:infoctess_koneqt/widgets/status_snack.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String selectedGroup = "";
  String selectedGender = "";
  String selectedLevel = "";

  XFile? selectedMedia;
  CroppedFile? croppedMedia;
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

  Future<void> cropImage() async {
    if (selectedMedia != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedMedia!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50, // 50% compression
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

//pick image from gallery
  Future<void> uploadImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedMedia = pickedFile;
      });
    }
  }

//pick image from camera
  Future<void> uploadImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedMedia = pickedFile;
      });
    }
  }

  //clear image
  void clearImage() {
    setState(() {
      selectedMedia = null;
      croppedMedia = null;
    });
  }

  User user = User();
  @override
  void initState() {
    super.initState();
    _fnameController.text = auth.currentUser!.displayName!;
    getUser();
  }

  void getUser() async {
    await Auth().getUserInfo().then(
          (value) => setState(() {
            _userNameController.text = curUser?.userName ?? "";
            _phoneController.text = curUser?.phoneNum ?? "";
            selectedGender = curUser?.gender ?? "";
            selectedGroup = curUser?.classGroup ?? "";
            selectedLevel = curUser?.userLevel ?? "";
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: cSec.withOpacity(0.1),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 20.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Choose Profile Image",
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(height: 10.w),
                Stack(
                  children: [
                    selectedMedia != null
                        ? ClipOval(
                            child: Image.file(
                              File(selectedMedia!.path),
                              width: 35.vw,
                              height: 35.vw,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: cPri,
                            radius: 50.r,
                            backgroundImage: CachedNetworkImageProvider(
                                auth.currentUser!.photoURL!),
                          ),
                    Positioned(
                      bottom: -2,
                      right: 2,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                          elevation: 2,
                        ),
                        onPressed: () async {
                          showImageDialog();
                        },
                        icon: const Icon(Icons.camera_alt_outlined),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                InputControl(
                  hintText: "Fullname",
                  type: TextInputType.name,
                  controller: _fnameController,
                  leading: const Icon(Icons.person),
                ),
                InputControl(
                  hintText: "Username",
                  type: TextInputType.name,
                  controller: _userNameController,
                  leading: const Icon(Icons.alternate_email),
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
                  controller: _phoneController,
                  leading: const Icon(Icons.phone),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Phone Number cannot be empty";
                    }
                    return null;
                  },
                ),
                SelectControl(
                  validator: (value) {
                    if (value == null) {
                      return "Please select a level";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedLevel = value!;
                    });
                  },
                  hintText: "Level",
                  items: levels.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                ),
                SelectControl(
                  validator: (value) {
                    if (value == null) {
                      return "Please select a class group";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedGroup = value!;
                    });
                  },
                  hintText: "Class Group",
                  items: classgroup.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  }).toList(),
                ),
                SelectControl(
                  validator: (value) {
                    if (value == null) {
                      return "Please select a class group";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  hintText: "Gender",
                  items: gender.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.w),
                Container(
                  margin: EdgeInsets.only(bottom: 20.w),
                  width: 100.vw,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: Image.asset(
                                "assets/images/preload.gif",
                                width: 30.w,
                                height: 30.w,
                              ),
                            ),
                          );
                          await Auth()
                              .updateUserInfo(
                                fullName: _fnameController.text.trim(),
                                userName: _userNameController.text.trim(),
                                phoneNum: _phoneController.text.trim(),
                                gender: selectedGender,
                                classGroup: selectedGroup,
                                level: selectedLevel,
                              )
                              .then((value) => {
                                    Navigator.pop(context),
                                    CustomSnackBar.show(
                                      context,
                                      message: "Profile Updated!",
                                    ),
                                  });
                        }
                      } catch (e) {
                        CustomSnackBar.show(
                          context,
                          message: "Failed try again!",
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cPri,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // show camera/gallery dialog
  void showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: const Text("Choose Image"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    uploadImageFromCamera().then((value) => cropImage());
                  },
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text("Camera"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    uploadImageFromGallery().then((value) => cropImage());
                  },
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text("Gallery"),
                ),
              ],
            ),
          );
        }
        return CupertinoAlertDialog(
          title: const Text("Choose Image"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  uploadImageFromCamera().then((value) => cropImage());
                },
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt_outlined),
                    SizedBox(
                      width: 10.w,
                    ),
                    const Text("Camera"),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  uploadImageFromGallery().then((value) => cropImage());
                },
                child: Row(
                  children: [
                    const Icon(Icons.photo_library_outlined),
                    SizedBox(
                      width: 10.w,
                    ),
                    const Text("Gallery"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

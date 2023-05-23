import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/news_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

class CreateNews extends StatefulWidget {
  const CreateNews({super.key});

  @override
  State<CreateNews> createState() => _CreateNewsState();
}

class _CreateNewsState extends State<CreateNews> {
  final QuillController _quillController = QuillController.basic();
  late final _content = _quillController.document.toDelta();

  final titleController = TextEditingController();
  Map<String, String> fontSizes = {
    "16": "16",
    "20": "20",
    "24": "24",
    "28": "28",
    "32": "32",
    "36": "26",
    "40": "40",
    "44": "44",
    "48": "48",
    "52": "52",
  };

  bool isEmtpyText = true;

  // XFile? selectedImage;
  // File? selectedVideo;
  // bool hasMedia = false;
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

  void clear() {
    setState(() {
      selectedMedia = null;
      croppedMedia = null;
    });
  }

  /// Get video from gallery

  Future<String> getUserID() async {
    final userPrefs = await mainPrefs;
    return userPrefs.getString("userID")!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    _quillController.dispose();
    selectedMedia = null;
    croppedMedia = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 100,
          title: const Text("Create a News Post"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: ScrollController(),
              child: SizedBox(
                height: 100.vh,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          child: AnimatedContainer(
                            margin: EdgeInsets.only(bottom: 10.h),
                            duration: const Duration(milliseconds: 200),
                            height: 30.vh,
                            width: 80.vw,
                            child:
                                (croppedMedia != null || selectedMedia != null)
                                    ? _imageCard()
                                    : Image.asset(
                                        "assets/images/placeholder.png",
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 0,
                          child: IconButton(
                            style: IconButton.styleFrom(
                              shape: const CircleBorder(),
                              elevation: 5,
                              padding: EdgeInsets.all(12.w),
                              backgroundColor: cSec,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              await uploadImage().then((value) => cropImage());
                            },
                            icon: const Icon(Icons.add_a_photo_outlined),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      style: TextStyle(fontSize: 16.sp + 1),
                      controller: titleController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'News Title',
                        fillColor: const Color.fromRGBO(217, 217, 217, 0.6),
                        filled: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: cSec,
                            width: 2,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: cSec.withOpacity(0.8),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      child: QuillToolbar.basic(
                        multiRowsDisplay: false,
                        iconTheme: const QuillIconTheme(
                          iconUnselectedColor: Colors.black87,
                        ),

                        axis: Axis.horizontal,
                        controller: _quillController,
                        showAlignmentButtons: true,
                        showCodeBlock: true,
                        showColorButton: true,
                        showClearFormat: true,
                        showBackgroundColorButton: false,
                        showHeaderStyle: false,
                        showLink: true,
                        showQuote: false,
                        showDividers: true,
                        fontSizeValues: fontSizes,
                        // showImageButton: false,
                        // showVideoButton: false,
                        showInlineCode: false,
                      ),
                    ),
                    Flexible(
                      flex: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 6,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 0),
                              // height: 30.vh,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: cSec,
                                ),
                              ),
                              child: QuillEditor(
                                maxHeight: 20.vh,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                scrollable: true,
                                expands: true,
                                autoFocus: false,
                                focusNode: FocusNode(),
                                padding: EdgeInsets.all(10.w),
                                scrollController: ScrollController(),
                                controller: _quillController,
                                readOnly: false,
                                customStyles: DefaultStyles(
                                  paragraph: DefaultTextBlockStyle(
                                    TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.sp + 1,
                                    ),
                                    const VerticalSpacing(8, 0),
                                    const VerticalSpacing(0, 0),
                                    null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            height: 50.h,
                            child: TextButton(
                              onPressed: () {
                                if (titleController.text.isNotEmpty &&
                                    _content.isNotEmpty) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => Center(
                                      child: Image.asset(
                                        "assets/images/preload.gif",
                                        width: 50.w,
                                        height: 50.w,
                                      ),
                                    ),
                                  );
                                  // send the news post
                                  var json = jsonEncode(_content.toJson());
                                  postNews(
                                    titleController.text,
                                    json,
                                    imagePath: croppedMedia?.path,
                                  ).then(
                                    (value) {
                                      Navigator.pop(context);
                                      StatusAlert.show(
                                        context,
                                        duration: const Duration(seconds: 2),
                                        title: "Sent",
                                        titleOptions:
                                            StatusAlertTextConfiguration(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp + 1,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        maxWidth: 50.vw,
                                        configuration: IconConfiguration(
                                          icon: Icons.check,
                                          color: Colors.green,
                                          size: 50.w,
                                        ),
                                      );
                                      setState(() {
                                        titleController.clear();
                                        croppedMedia = null;
                                        selectedMedia = null;
                                      });
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  );
                                } else {
                                  SnackBar snackBar = SnackBar(
                                    content:
                                        const Text("Please fill in all fields"),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: cSec,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              style: TextButton.styleFrom(
                                  minimumSize: btnLarge(context),
                                  maximumSize: btnLarge(context),
                                  fixedSize: btnLarge(context),
                                  backgroundColor: cPri,
                                  foregroundColor: Colors.white),
                              child: Text(
                                "Post News",
                                style: TextStyle(fontSize: 16.sp + 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _image() {
    if (croppedMedia != null) {
      final path = croppedMedia!.path;
      return Image.file(
        File(path),
        fit: BoxFit.cover,
      );
      // ConstrainedBox(
      //   constraints: BoxConstraints(
      //     maxWidth: 100.vw,
      //     maxHeight: 40.vh,
      //     minHeight: 30.vh,
      //     minWidth: 40.vw,
      //   ),
      // child:
      // );
      // } else if (selectedMedia != null) {
      //   final path = selectedMedia!.path;
      //   return ConstrainedBox(
      //     constraints: BoxConstraints(
      //       maxWidth: 0.8 * screenWidth,
      //       maxHeight: 0.2 * screenHeight,
      //     ),
      //     child: Image.file(File(path)),
      //   );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Stack(
        children: [
          Card(
            // elevation: 1.0,

            child: _image(),
          ),
          Positioned(
            top: 4.h,
            right: 4.w,
            width: 20.w,
            height: 20.h,
            child: IconButton(
              style: IconButton.styleFrom(
                padding: EdgeInsets.all(5.r),
                backgroundColor: Colors.white,
                // side: BorderSide(color: Colors.white, width: 1),
              ),
              onPressed: clear,
              icon: const Icon(CupertinoIcons.clear_thick),
              iconSize: 12.w,
            ),
          ),
          // const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}

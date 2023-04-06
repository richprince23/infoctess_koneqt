import 'dart:io';

import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/controllers/post_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => CreatePostState();
}

class CreatePostState extends State<CreatePost> {
  FocusNode focusNode = FocusNode();
  final postController = TextEditingController();

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
    focusNode.dispose();
    selectedMedia = null;
    croppedMedia = null;
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      // padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DetectableTextField(
            detectionRegExp:
                detectionRegExp(hashtag: true, atSign: true, url: true)!,
            onChanged: ((value) {
              postController.text.isEmpty
                  ? isEmtpyText = true
                  : isEmtpyText = false;
              setState(() {});
            }),
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            keyboardType: TextInputType.multiline,
            inputFormatters: [
              LengthLimitingTextInputFormatter(500),
            ],
            controller: postController,
            minLines: 1,
            maxLines: 4,
            focusNode: focusNode,
            // maxLength: 500,
            // autofocus: true,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                alignLabelWithHint: false,
                hintText: "What's up, Richard?",
                hintStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: AppTheme.themeData(false, context).focusColor),
                ),
                focusColor: AppTheme.themeData(false, context).focusColor),
            basicStyle: GoogleFonts.sarabun(),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            child: (croppedMedia != null || selectedMedia != null)
                ? _imageCard()
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      fixedSize: const Size(20, 20)),
                  onPressed: () => focusNode.hasFocus
                      ? FocusScope.of(context).unfocus()
                      : FocusScope.of(context).requestFocus(),
                  icon: const Icon(CupertinoIcons.keyboard),
                  iconSize: 18,
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    fixedSize: const Size(70, 26),
                    minimumSize: const Size(70, 26),
                    maximumSize: const Size(70, 26),
                  ),
                  onPressed: () async {
                    await uploadImage().then((value) => cropImage());
                  },
                  icon: const Icon(
                    CupertinoIcons.camera,
                    size: 12,
                  ),
                  label: const Text(
                    "image",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    " ${postController.text.length}/ 500",
                    style: const TextStyle(
                        fontSize: 10, fontStyle: FontStyle.italic),
                  ),
                ),
                TextButton(
                  onPressed: (() {
                    if (!isEmtpyText) {
                      if (croppedMedia != null) {
                        sendPost(postController.text,
                            imagePath: croppedMedia!.path);
                      } else {
                        sendPost(postController.text.trim());
                      }
                    }
                  }),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    fixedSize: const Size(60, 20),
                    alignment: Alignment.center,
                    backgroundColor: !isEmtpyText ||
                            selectedMedia != null ||
                            croppedMedia != null
                        ? AppTheme.themeData(false, context).backgroundColor
                        : Colors.transparent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("post"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (croppedMedia != null) {
      final path = croppedMedia!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.2 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else if (selectedMedia != null) {
      final path = selectedMedia!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.2 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
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
            top: 4,
            right: 4,
            width: 20,
            height: 20,
            child: IconButton(
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(5),
                backgroundColor: Colors.white,
                // side: BorderSide(color: Colors.white, width: 1),
              ),
              onPressed: clear,
              icon: const Icon(CupertinoIcons.clear),
              iconSize: 12,
            ),
          ),
          // const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}

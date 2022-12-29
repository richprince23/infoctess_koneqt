import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/screens/trimmer_view.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:video_player/video_player.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => CreatePostState();
}

class CreatePostState extends State<CreatePost> {
  FocusNode focusNode = FocusNode();
  final postController = TextEditingController();
  late VideoPlayerController vidController;

  bool isEmtpyText = true;

  XFile? selectedImage;
  XFile? selectedVideo;
  // bool hasMedia = false;
  XFile? selectedMedia;
  CroppedFile? croppedMedia;

  Future<void> cropImage() async {
    if (selectedMedia != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedMedia!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 80,
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
          selectedMedia = croppedFile as XFile;
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
  Future uploadVideo() async {
    XFile? pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 30));
    setState(() {
      selectedVideo = pickedFile;
      selectedMedia = pickedFile;
    });
  }

  Future trimVideo() async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postController.dispose();
    // vidController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      // padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextField(
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
            style: GoogleFonts.sarabun(),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            child: (croppedMedia != null || croppedMedia != null)
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
                IconButton(
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.black,
                    // side: const BorderSide(color: Colors.grey, width: 1),
                    // padding: const EdgeInsets.symmetric(horizontal: 4),
                    // fixedSize: const Size(60, 20),
                  ),
                  onPressed: () async {
                    await uploadImage().then((value) => cropImage());
                    // cropImage();
                  },
                  icon: const Icon(
                    CupertinoIcons.camera,
                    size: 16,
                  ),
                ),
                IconButton(
                  style: OutlinedButton.styleFrom(
                    textStyle: GoogleFonts.sarabun(),
                    foregroundColor: Colors.black,
                    // side: const BorderSide(color: Colors.grey, width: 1),
                    // padding: const EdgeInsets.symmetric(horizontal: 4),
                    // fixedSize: const Size(60, 20),
                  ),
                  onPressed: () async {
                    await uploadVideo().then((value) => Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: ((context) =>
                                TrimmerView(selectedVideo as File)))));
                  },
                  icon: const Icon(
                    CupertinoIcons.film,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    "${postController.text.length}/ 500",
                    style: const TextStyle(
                        fontSize: 10, fontStyle: FontStyle.italic),
                  ),
                ),
                TextButton(
                  onPressed: (() {
                    isEmtpyText ? null : print("sent");
                  }),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    fixedSize: const Size(60, 20),
                    alignment: Alignment.center,
                    backgroundColor: !isEmtpyText
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
          maxHeight: 0.4 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else if (selectedMedia != null) {
      final path = selectedMedia!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.4 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _video() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (croppedMedia != null) {
      final path = croppedMedia!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.4 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else if (selectedMedia != null) {
      final path = selectedMedia!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.4 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: clear,
            icon: const Icon(CupertinoIcons.clear),
            iconSize: 12,
          ),
          Card(
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _image(),
            ),
          ),
          // const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}

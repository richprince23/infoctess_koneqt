import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:resize/resize.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  List<XFile?>? selectedFiles;
  final pageScroller = ScrollController();
  final imagesScroller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    selectedFiles = null;
    pageScroller.dispose();
    imagesScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Help & Support"),
      ),
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          controller: pageScroller,
          scrollDirection: Axis.vertical,
          child: Container(
            height: 100.vh,
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                SizedBox(
                  height: 20.w,
                ),
                Text(
                  "Help & Support",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.w,
                ),
                Text(
                  "We are here to help you. If you have any questions or issues, please send us a message and we will get back to you as soon as possible.",
                  style: TextStyle(fontSize: 16.sp),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.w,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText:
                              "Tell us how we can help you. You can include screenshots or error messages.",
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                        ),
                        maxLines: 8,
                      ),
                      // SizedBox(
                      //   height: 20.w,
                      // ),
                      SizedBox(
                        width: 100.vw,
                        height: 60.w,
                        child: selectedFiles != null
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: imagesScroller,
                                child: Row(
                                  children:
                                      // Image.file(File(selectedFiles![0]!.path)),
                                      List.generate(selectedFiles!.length,
                                          (index) {
                                    return Container(
                                      margin: EdgeInsets.all(6.w),
                                      child: Image.file(
                                        File(selectedFiles![index]!.path),
                                        width: 48.w,
                                        height: 48.w,
                                      ),
                                    );
                                  }),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              await uploadImageFromGallery();
                            },
                            child: const Text("Add screenshots"),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          selectedFiles != null
                              ? OutlinedButton(
                                  onPressed: () async {
                                    setState(() {
                                      selectedFiles = null;
                                    });
                                  },
                                  child: const Text("Clear images"),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(
                        height: 20.w,
                      ),
                      SizedBox(
                        width: 100.vw,
                        height: 48.w,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: cPri,
                            textStyle: TextStyle(fontSize: 16.sp),
                          ),
                          onPressed: () {},
                          child: const Text("Send message"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //pick image from gallery
  Future<void> uploadImageFromGallery() async {
    final pickedFile = await ImagePicker().pickMultiImage();
    if (pickedFile.isNotEmpty) {
      setState(() {
        selectedFiles = pickedFile;
      });
    }
  }
}

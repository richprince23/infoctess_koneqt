import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:resize/resize.dart';

class MediaPreview extends StatelessWidget {
  final String chatID;
  final String filePath;
  final captionController = TextEditingController();
  MediaPreview({super.key, required this.chatID, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Container(
        height: 90.vh,
        // margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Media Preview",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      // elevation: 0,
                      shape: const CircleBorder(),
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            //change this to dynamic media by checking mime type
            Expanded(
              child: Image.file(
                File(filePath),
                fit: BoxFit.contain,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
              child: Row(children: [
                Expanded(
                  child: InputControl(
                    showLabel: false,
                    hintText: "Add a caption",
                    type: TextInputType.multiline,
                    controller: captionController,
                    isCollapsed: true,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(10.w),
                    backgroundColor: cPri,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (captionController.text.isNotEmpty) {
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
                      await sendMessage(
                        chatID: chatID,
                        attachment: filePath,
                        message: captionController.text.trim(),
                      )
                          .then(
                            (value) => {
                              captionController.clear(),
                              Navigator.pop(context),
                            },
                          )
                          .then(
                            (value) => Navigator.pop(context),
                          );
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

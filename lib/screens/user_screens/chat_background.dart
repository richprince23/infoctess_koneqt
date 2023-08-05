import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';
import 'package:infoctess_koneqt/widgets/status_snack.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class ChatBackgroundScreen extends StatefulWidget {
  const ChatBackgroundScreen({super.key});

  @override
  State<ChatBackgroundScreen> createState() => _ChatBackgroundScreenState();
}

class _ChatBackgroundScreenState extends State<ChatBackgroundScreen> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Backgound"),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false)
                  .setBackgroundImage(path: "")
                  .then(
                    (value) => 
                      CustomSnackBar.show(context,
                        message: "Chat background has been reset",                      
                    ),
                  );
            },
            child: const Text("reset"),
          )
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text("Choose from Gallery"),
            onTap: () async {
              await chooseImage();
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.color_lens),
          //   title: const Text("Choose from Solid Colors"),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.format_paint),
          //   title: const Text("Choose Font Color"),
          //   onTap: () {},
          // ),
          SizedBox(
            height: 10.w,
          ),
          const Divider(),
          SizedBox(
            height: 10.w,
          ),
          const Text("Preview"),
          SizedBox(
            height: 10.w,
          ),
          Container(
            height: 50.vh,
            width: 60.vw,
            decoration: BoxDecoration(
              color: cSec.withOpacity(0.05),
              image: context.watch<ChatProvider>().chatBackground != ""
                  ? DecorationImage(
                      opacity: 0.8,
                      image: FileImage(
                          File(context.watch<ChatProvider>().chatBackground)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                if (_image != null)
                  Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    height: 50.vh,
                    width: 60.vw,
                  ),
                Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: ChatBubble(
                        message: "Hello",
                        isUser: false,
                        showAvatar: false,
                        // fontColor: Colors.white,
                        hasOptions: false,
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: ChatBubble(
                        hasOptions: false,
                        message: "Hi there",
                        isUser: true,
                        showAvatar: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            // height: 50.w,
            width: 60.vw,
            child: _image != null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cPri,
                      elevation: 0,
                      foregroundColor: Colors.white,
                      fixedSize: btnLarge(context),
                    ),
                    onPressed: () async {
                      await Provider.of<ChatProvider>(context, listen: false)
                          .setBackgroundImage(path: _image!.path)
                          .then(
                            (value) => Navigator.pop(context),
                          );
                    },
                    child: Text(
                      "save",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          SizedBox(
            height: 20.w,
          ),
        ],
      ),
    );
  }

  //choose from gallery
  Future<void> chooseImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';
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
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("Choose from Solid Colors"),
            onTap: () {},
          ),
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
            color: Colors.blue,
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ChatBubble(
                        message: "Hello",
                        isUser: false,
                        showAvatar: false,
                        // fontColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Align(
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
          )
        ],
      ),
    );
  }

  // //choose solid color
  // Color chooseColor() {
  //   ColorP
  // }

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

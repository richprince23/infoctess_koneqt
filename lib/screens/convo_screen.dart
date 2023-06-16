import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/screens/user_screens/profile_screen.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';
import 'package:infoctess_koneqt/widgets/chat_preview.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class ConvoScreen extends StatefulWidget {
  final Poster sender;
  final String chatID;

  const ConvoScreen({super.key, required this.sender, required this.chatID});

  @override
  State<ConvoScreen> createState() => _ConvoScreenState();
}

class _ConvoScreenState extends State<ConvoScreen> {
  final msgController = TextEditingController();
  bool? isTyping;
  bool isEmpty = true;
  XFile? selectedMedia;
  CroppedFile? croppedMedia;

  @override
  void initState() {
    super.initState();
    markChatAsRead(chatID: widget.chatID);
    msgController.addListener(() {
      setState(() {
        msgController.text.isEmpty ? isTyping = false : isTyping = true;
        msgController.text.isEmpty ? isEmpty = true : isEmpty = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    msgController.dispose();
    selectedMedia = null;
    croppedMedia = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.5,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: cSec.withOpacity(0.1),
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  userID: widget.sender.posterID!,
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 15.r,
                backgroundImage: CachedNetworkImageProvider(
                  widget.sender.posterAvatarUrl!,
                  // "https://i.pravatar.cc/150?img=3",
                  errorListener: () => const Icon(Icons.person),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sender.posterName ?? "User",
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("online", style: TextStyle(fontSize: 12.sp)),
                ],
              ),
            ],
          ),
        ),
        // actions: [],
      ),
      body: KeyboardDismissOnTap(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                color: cSec.withOpacity(0.05),
                child: StreamBuilder(
                  stream: db
                      .collection("chats")
                      .doc(widget.chatID)
                      .collection("messages")
                      .orderBy("timestamp", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: EmptyList(
                          text:
                              "You don't have any messages yet\nStart a conversation with ${widget.sender.posterName} to see them here",
                        ),
                      );
                    }
                    // Get the documents that have been deleted.
                    return ListView.builder(
                      cacheExtent: 100.vh,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // Get the list of documents
                        // List<DocumentSnapshot> documents = snapshot.data!.docs;
                        // // Remove any deleted documents
                        // documents.removeWhere(
                        //     (document) => document.exists == false);

                        final data = snapshot.data!.docs[index];
                        return ChatBubble(
                          message: data['message'],
                          isUser: data['senderID'] == auth.currentUser!.uid,
                          hasTime: true,
                          time: data['timestamp'].toDate().toString(),
                          showAvatar: false,
                          mediaUrl: data['mediaUrl'] ?? "",
                          msgID: data.id,
                          chatID: widget.chatID,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              // height: 60,
              padding: EdgeInsets.all(5.w),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _showAttachMediaModal(context);
                    },
                    icon: const Icon(Icons.add),
                    iconSize: 24.w,
                    color: cPri,
                  ),
                  Expanded(
                    child: InputControl(
                      showLabel: false,
                      hintText: "Type a message",
                      type: TextInputType.multiline,
                      controller: msgController,
                      isCollapsed: true,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  isEmpty == true
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.mic),
                          iconSize: 24.w,
                          color: cPri,
                        )
                      : IconButton(
                          style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: EdgeInsets.all(10.w),
                            backgroundColor: cPri,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (msgController.text.isNotEmpty) {
                              await sendMessage(
                                chatID: widget.chatID,
                                message: msgController.text.trim(),
                              );
                              msgController.clear();
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  void clear() {
    setState(() {
      selectedMedia = null;
      croppedMedia = null;
    });
  }

  // Attach media modal widget
  Future<void> _showAttachMediaModal(BuildContext context) async {
    Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              title: const Text('Attach Media'),
              // message: const Text('Select media to attach'),
              cancelButton: CupertinoActionSheetAction(
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context, 'cancel');
                },
              ),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.camera, color: cPri),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Text('Camera')
                      ]),
                  onPressed: () {
                    Navigator.pop(context, 'Camera');
                  },
                ),
                CupertinoActionSheetAction(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.photo, color: cPri),
                      SizedBox(
                        width: 10.w,
                      ),
                      const Text('Gallery'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'Gallery');
                  },
                ),
                CupertinoActionSheetAction(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.doc, color: cPri),
                      SizedBox(
                        width: 10.w,
                      ),
                      const Text('File'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'File');
                  },
                ),
              ],
            ),
          )
        : showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt,
                    ),
                    title: const Text('Camera'),
                    onTap: () async {
                      await uploadImageFromCamera()
                          .then((value) => cropImage())
                          .then(
                            (value) => {
                              Navigator.pop(context),
                              showModalBottomSheet(
                                // isDismissible: true,
                                isScrollControlled: true,
                                enableDrag: true,
                                context: context,
                                builder: ((context) {
                                  return MediaPreview(
                                    chatID: widget.chatID,
                                    filePath: croppedMedia!.path,
                                  );
                                }),
                              ),
                            },
                          );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('Gallery'),
                    onTap: () async {
                      await uploadImageFromGallery()
                          .then((value) => cropImage())
                          .then(
                            (value) => {
                              Navigator.pop(context),
                              showModalBottomSheet(
                                // isDismissible: true,
                                isScrollControlled: true,
                                enableDrag: true,
                                context: context,
                                builder: ((context) {
                                  return MediaPreview(
                                    chatID: widget.chatID,
                                    filePath: croppedMedia!.path,
                                  );
                                }),
                              ),
                            },
                          );
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: const Text('File'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          scrolledUnderElevation: 1,
          surfaceTintColor: cSec.withOpacity(0.1),
          title: Row(
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
          // actions: [],
        ),
        body: Column(
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
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ChatBubble(
                          message: snapshot.data!.docs[index]['message'],
                          isUser: snapshot.data!.docs[index]['senderID'] ==
                              auth.currentUser!.uid,
                          hasTime: true,
                          showAvatar: false,
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
                              // await sendMessage(
                              //   chatID: widget.chatID,
                              //   message: msgController.text,
                              //   senderID: auth.currentUser!.uid,
                              // );
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.video_library),
                    title: const Text('Video'),
                    onTap: () {
                      Navigator.pop(context);
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

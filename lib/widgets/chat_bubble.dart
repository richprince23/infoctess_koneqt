import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

class ChatBubble extends StatelessWidget {
  bool isUser;
  String message;
  String? avatar;
  bool showAvatar;
  bool hasTime;
  String time;
  String? mediaUrl;
  bool hasOptions;
  String msgID;
  String chatID;
  Color fontColor;

  ChatBubble(
      {required this.isUser,
      required this.message,
      this.msgID = "",
      this.chatID = "",
      this.avatar,
      this.showAvatar = true,
      this.mediaUrl,
      this.hasTime = false,
      this.time = "",
      this.hasOptions = true,
      this.fontColor = Colors.black,
      super.key});

  @override
  Widget build(BuildContext context) {
    Color getBubbleColor() {
      if (isUser) {
        // return Colors.black87;
        return const Color(0xFFFFD9F0);
      } else {
        // return Colors.black54;
        return Colors.white;
      }
    }

    return InkWell(
      onLongPress: () {
        if (hasOptions == true) {
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: ((context) {
              return buildChatOptions(context);
            }),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUser == false && showAvatar == true)
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  avatar != null ? CachedNetworkImageProvider(avatar!) : null,
              backgroundColor: avatar == null ? Colors.white : null,
              child: avatar == null
                  ? const Icon(
                      Icons.person,
                      color: Colors.black,
                    )
                  : null,
            ),
          Flexible(
            fit: FlexFit.loose,
            child: IntrinsicWidth(
              child: Container(
                // elevation: 0,
                alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                margin: const EdgeInsets.all(8),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
                decoration: ShapeDecoration(
                  color: getBubbleColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser
                          ? const Radius.circular(16)
                          : const Radius.circular(0),
                      bottomRight: isUser
                          ? const Radius.circular(0)
                          : const Radius.circular(16),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: isUser == true
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildMediaPreview(),
                    Text(
                      message,
                      style: TextStyle(
                        color: fontColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    if (hasTime == true && time != "")
                      Text(
                        convertTime(time),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (isUser == true && showAvatar == true)
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  avatar != null ? CachedNetworkImageProvider(avatar!) : null,
              backgroundColor: avatar == null ? Colors.white : null,
              child: avatar == null
                  ? const Icon(
                      Icons.person,
                      color: Colors.black,
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  buildMediaPreview() {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2)).then((_) => mediaUrl),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null && snapshot.data != '') {
          String fileUrl = snapshot.data!.split("?")[0];
          String mime = lookupMimeType(fileUrl)!;
          String fileName = path.basename(fileUrl.split("%").last).toString();

          if (mime.contains("image")) {
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageViewer(image: mediaUrl!),
                ),
              ),
              child: IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  child: CachedNetworkImage(
                    imageUrl: mediaUrl!,
                    placeholder: (context, url) => Icon(
                      Icons.photo,
                      size: 80.w,
                    ),
                    errorWidget: (context, url, error) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(10.w),
              width: 60.vw,
              decoration: ShapeDecoration(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(color: cPri, width: 0.5),
                ),
              ),
              child: Text(
                "File: $fileName",
                style: TextStyle(color: Colors.black, fontSize: 12.sp),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }

  buildChatOptions(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.all(40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  color: Colors.white,
                  child: SizedBox(
                    width: 100.vw,
                    child: ChatBubble(
                      isUser: isUser,
                      message: message,
                      showAvatar: false,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Reply"),
                          leading: const Icon(CupertinoIcons.reply),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text("Forward"),
                          leading: const Icon(
                              CupertinoIcons.arrowshape_turn_up_right),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text("Copy"),
                          leading: const Icon(CupertinoIcons.doc_on_doc),
                          onTap: () {
                            //copy to clipboard
                            Clipboard.setData(ClipboardData(text: message))
                                .then(
                              (value) => Navigator.pop(context),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text("Delete"),
                          leading: const Icon(CupertinoIcons.delete),
                          onTap: () async {
                            await deleteMessage(
                                    chatID: chatID, messageID: msgID)
                                .then(
                              (value) => Navigator.pop(context),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Cancel"),
                          leading: const Icon(CupertinoIcons.xmark_circle_fill),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
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
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:resize/resize.dart';

class ChatBubble extends StatelessWidget {
  bool isUser;
  String message;
  String? avatar;
  bool showAvatar;
  bool hasTime;
  String time;
  String? mediaUrl;

  ChatBubble(
      {required this.isUser,
      required this.message,
      this.avatar,
      this.showAvatar = true,
      this.mediaUrl,
      this.hasTime = false,
      this.time = "",
      super.key});

  @override
  Widget build(BuildContext context) {
    Color getBubbleColor() {
      if (isUser) {
        // return Colors.black87;
        return cPri.withOpacity(0.1);
      } else {
        // return Colors.black54;
        return cSec.withOpacity(0.1);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isUser == false && showAvatar == true)
          CircleAvatar(
            radius: 15.r,
            backgroundColor: Colors.black,
            child: const Text(
              "AI",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildMediaPreview(),
                  SelectableText(
                    message,
                    style: TextStyle(
                      color: Colors.black,
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
              ),
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';

class ChatBubble extends StatelessWidget {
  bool isUser;
  String message;
  String? avatar;
  bool showAvatar;
  bool hasTime;

  ChatBubble(
      {required this.isUser,
      required this.message,
      this.avatar,
      this.showAvatar = true,
      this.hasTime = false,
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
        if (isUser == false && showAvatar! == true)
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
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  if (hasTime == true)
                    Text(
                      convertToElapsedString(DateTime.now().toString())
                      //TODO: Add dynamic time here
                      ,
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
}

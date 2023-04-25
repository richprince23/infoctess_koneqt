import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class ChatItem extends StatelessWidget {
  bool isUser;
  String message;
  String? avatar;

  ChatItem(
      {required this.isUser, required this.message, this.avatar, super.key});

  @override
  Widget build(BuildContext context) {
    Color getBubbleColor() {
      if (isUser) {
        // return Colors.black87;
        return AppTheme.themeData(false, context).backgroundColor;
      } else {
        // return Colors.black54;
        return AppTheme.themeData(false, context).indicatorColor;
      }
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(8),
        color: getBubbleColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isUser ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight:
                isUser ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isUser == false)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    // ignore: unnecessary_const
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black,
                      child: Text(
                        "AI",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (isUser == true)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: avatar != null
                          ? CachedNetworkImageProvider(avatar!)
                          : null,
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
            ],
          ),
        ),
      ),
    );
  }
}

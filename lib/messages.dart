import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:resize/resize.dart';

class ChatlistScreen extends StatelessWidget {
  const ChatlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(
              10.w,
            ),
            child: Text(
              "Messages",
              style: TextStyle(
                fontSize: 18.sp + 1,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: null,
              builder: (context, snapshot) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        margin: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 10.w),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w),
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundImage: CachedNetworkImageProvider(
                                curUser?.avatar ??
                                    "https://i.pravatar.cc/150?img=3",
                                errorListener: () => const Icon(
                                    Icons.account_circle,
                                    color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "User Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    "Last Message",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            Badge.count(
                              count: 10,
                              backgroundColor: cSec,
                              textColor: Colors.white,
                              // textStyle: TextStyle(fontSize: 18.sp),
                              // largeSize: 30,
                              // padding: EdgeInsets.all(5.w),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class UserAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 40.r,
                  backgroundImage: CachedNetworkImageProvider(
                    curUser!.avatar!,
                    errorListener: () => const Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      curUser!.fullName!,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      curUser!.emailAddress!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                      label: Text("Edit Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cPri,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "Social",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => Navigator.pushNamed(context, '/my-friends'),
                      iconColor: cSec,
                      leading: const Icon(Icons.people_outline),
                      title: Text(
                        "Friends",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      onTap: () => Navigator.pushNamed(context, '/my-activity'),
                      iconColor: cSec,
                      leading: const Icon(Icons.show_chart_rounded),
                      title: Text(
                        "My Activity",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "Chats",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () =>
                          Navigator.pushNamed(context, '/starred-messages'),
                      iconColor: cSec,
                      leading: const Icon(Icons.star_border),
                      title: Text(
                        "Starred Messages",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      onTap: () =>
                          Navigator.pushNamed(context, '/chat-background'),
                      iconColor: cSec,
                      leading: const Icon(Icons.show_chart_rounded),
                      title: Text(
                        "Chat Background",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      iconColor: cSec,
                      leading: const Icon(Icons.photo_library_outlined),
                      title: Text(
                        "My Shared Media",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "General, Privacy, Security",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ListTile(
                      iconColor: cSec,
                      leading: const Icon(Icons.help_outline),
                      title: Text(
                        "Help and Support",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      iconColor: cSec,
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      iconColor: cSec,
                      leading: const Icon(Icons.handshake_outlined),
                      title: Text(
                        "Terms and Conditions",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "Storage and Data",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ListTile(
                      iconColor: cSec,
                      leading: const Icon(Icons.delete_forever_outlined),
                      title: Text(
                        "Clear All Chats",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      iconColor: cSec,
                      leading: const Icon(Icons.sd_storage_outlined),
                      title: Text(
                        "Clear Cache",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      iconColor: Colors.red,
                      leading: const Icon(Icons.warning_amber_rounded),
                      title: Text(
                        "Delete Account",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  color: cPri,
                ),
                child: ListTile(
                  iconColor: Colors.white,
                  leading: const Icon(Icons.logout),
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

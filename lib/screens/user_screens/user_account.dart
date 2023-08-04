import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/status_snack.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: cSec.withOpacity(0.05),
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
                    auth.currentUser!.photoURL!,
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
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit-profile');
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
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
                    // ListTile(
                    //   onTap: () =>
                    //       Navigator.pushNamed(context, '/starred-messages'),
                    //   leading: const Icon(Icons.star_border),
                    //   title: Text(
                    //     "Starred Messages",
                    //     style: TextStyle(
                    //       fontSize: 14.sp,
                    //       fontWeight: FontWeight.w400,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    //   trailing: const Icon(Icons.arrow_forward_ios),
                    // ),
                    ListTile(
                      onTap: () =>
                          Navigator.pushNamed(context, '/chat-background'),
                      leading: const Icon(Icons.image_outlined),
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
                    // ListTile(
                    //   leading: const Icon(Icons.photo_library_outlined),
                    //   title: Text(
                    //     "My Shared Media",
                    //     style: TextStyle(
                    //       fontSize: 14.sp,
                    //       fontWeight: FontWeight.w400,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    //   trailing: const Icon(Icons.arrow_forward_ios),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "Privacy & Security",
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
                      onTap: () {
                        Navigator.pushNamed(context, '/help-support');
                      },
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
                      onTap: () {
                        Navigator.pushNamed(context, '/privacy-policy');
                      },
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
                      onTap: () {
                        Navigator.pushNamed(context, '/terms-and-conditions');
                      },
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
                "Storage & Data",
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
                      onTap: () async {
                        CustomDialog.showWithAction(context,
                            actionText: "Clear All",
                            title: "Clear all chats",
                            message:
                                "Are you sure you want to clear all your chats?",
                            action: () async {
                          await clearAllChats();
                        });
                      },
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
                      onTap: () async {
                        CustomDialog.showWithAction(context,
                            actionText: "Clear Cache",
                            title: "Clear Cache",
                            message:
                                "This action will clear all your cached media from your device.\nAre you sure you want to continue?",
                            action: () async {
                          try {
                            await clearCache();
                          } catch (e) {
                            CustomSnackBar.show(context,
                                message: "Error clearing cache");
                          }
                        });
                      },
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
                      onTap: () async {
                        CustomDialog.showWithAction(context,
                            actionText: "Still Delete",
                            title: "Delete Account",
                            message:
                                "Asay, why do you want to delete your account? ",
                            action: () async {
                          CustomSnackBar.show(context,
                              message: "Will delete when you complete school!");
                        });
                      },
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
                  onTap: () async {
                    CustomDialog.showWithAction(context,
                        actionText: "Logout",
                        title: "Logout",
                        message: "Are you sure you want to logout?",
                        alertStyle: AlertStyle.warning, action: () async {
                      try {
                        await auth.signOut().then(
                              (value) => {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .clearUserDetails()
                                    .then(
                                      (value) => CustomSnackBar.show(
                                        context,
                                        message: "Logged out",
                                      ),
                                    ),
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/login", (route) => false),
                              },
                            );
                      } catch (e) {
                        CustomSnackBar.show(context,
                            message: "Error logging out");
                      }
                    });
                  },
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

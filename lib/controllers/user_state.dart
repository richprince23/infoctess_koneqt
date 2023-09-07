import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/user_info.dart';
import 'package:provider/provider.dart';

class UserState extends ChangeNotifier {
  bool _isUserInit = false;
  MyUser? _curUser;
  // bool _isLoggedIn = false;

  get isUserInit => _isUserInit;

  MyUser? get curUser => _curUser;

  //save user info in shared prefs
  setCurUser(MyUser? user) async {
    _curUser = user;
    final userPrefs = await mainPrefs;
    userPrefs.setString('curUser', user!.toJson().toString());
    notifyListeners();
  }

  //get and save user details in
  Future<void> getUser(BuildContext context) async {
    // final userProvider = Provider.of<UserState>(context, listen: false);

    final userDoc = await FirebaseFirestore.instance
        .collection('user_infos')
        .doc(auth.currentUser!.uid)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data();
      final curUser = MyUser(
        avatar: userData!['avatar'] ?? "",
        emailAddress: userData['emailAddress'] ?? "",
        classGroup: userData['classGroup'] ?? "",
        fullName: userData['fullName'] ?? "",
        gender: userData['gender'] ?? "",
        indexNum: userData['indexNum'],
        phoneNum: userData['phoneNum'] ?? "",
        userLevel: userData['userLevel'] ?? "",
        userName: userData['userName'] ?? "",
        isAdmin: userData['isAdmin'] ?? false,
      );

      // _curUser = curUser;
      setCurUser(curUser);
    }
  }
}

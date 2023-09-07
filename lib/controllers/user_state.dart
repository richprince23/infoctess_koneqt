import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/user_info.dart';

class UserState extends ChangeNotifier {
  bool _isUserInit = false;
  MyUser? _curUser;
  // bool _isLoggedIn = false;

  get isUserInit => _isUserInit;

  MyUser? get curUser => _curUser;

  //save user info in shared prefs
  setCurUser(MyUser? user) async {
    _curUser = user;
    // curUser = user;
    final userPrefs = await mainPrefs;
    userPrefs.setString('curUser', user!.toJson().toString());
    _isUserInit = true;
    notifyListeners();
  }

  //retrieves user info from firestore and calls setCurUser to save in shared prefs
  Future<MyUser?> getUser(BuildContext context) async {
    // final userProvider = Provider.of<UserState>(context, listen: false);

    final userDoc = await FirebaseFirestore.instance
        .collection('user_infos')
        .where('userID', isEqualTo: auth.currentUser?.uid)
        // .snapshots();
        .get();

    if (userDoc.docs.isNotEmpty) {
      final userData = userDoc.docs.first;
      final curUser = MyUser(
        avatar: userData['avatar'] ?? "",
        emailAddress: auth.currentUser?.email ?? "",
        classGroup: userData['classGroup'] ?? "",
        fullName: userData['fullName'] ?? "",
        gender: userData['gender'] ?? "",
        indexNum: int.parse(userData['indexNum']),
        phoneNum: userData['phoneNum'] ?? "",
        userLevel: userData['userLevel'] ?? "",
        userName: userData['userName'] ?? "",
        isAdmin: userData['isAdmin'] ?? false,
      );

      // print("curUser is: ${curUser.toJson()}");
      // _curUser = curUser;
      setCurUser(curUser);
      return curUser;
    }
    return null;
  }
}

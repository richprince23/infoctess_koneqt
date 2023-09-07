import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/user_info.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  int? _indexNum;
  String? _firstName;
  // String _avatar = "";
  late bool _isLoggedIn;
  late String _userID;
  bool? _userInit = false;

  /// gets user's index number
  get indexNum async => _indexNum!;

  //get if the user has been initialized
  get userInit => _userInit;

  set avatar(String avatar) {
    curUser!.avatar = avatar;
    // setUser(curUser!);
    notifyListeners();
  }

  String get avatar {
    return curUser!.avatar!;
  }

  /// sets user's index number
  setPhoneNum(int? indexNum) async {
    final userPrefs = await mainPrefs;
    _indexNum = indexNum;
    userPrefs.setInt("phoneNum", indexNum!);
    notifyListeners();
  }

  /// gets user's id from shared preferences
  Future<String> getUserID() async {
    final userPrefs = await mainPrefs;
    _userID = userPrefs.getString("userID")!;
    return _userID;
  }

  ///sets user's id in shared preferences
  Future setUserID(String userID) async {
    _userID = userID;
    final userPrefs = await mainPrefs;
    userPrefs.setString("userID", userID);
    notifyListeners();
  }

  ///gets user's first name;
  String? get firstName => _firstName;

  ///sets user's firstname. Firstname is the first substring of user's fullname
  setFirstName(String? userName) async {
    final userPrefs = await mainPrefs;
    _firstName = userName!.split(" ")[0];
    userPrefs.setString("userName", _firstName!);
    notifyListeners();
  }

  /// gets user's info from UserInfo model
  Future<MyUser?> getUserInfo() async {
    return curUser;
  }

  /// sets a userinfo from a UserInfo model
  setUser(MyUser user) async {
    final userPrefs = await mainPrefs;
    userPrefs.setString('curUser', user.toJson().toString());
    setLoggedIn(true);
    notifyListeners();
  }

  Future getUser() async {
    final userPrefs = await mainPrefs;
    final res = userPrefs.getString("curUser");
    if (res != null) {
      curUser = MyUser.fromJson(json.decode(res) as Map<String, dynamic>);
      // curUser = myuser.User.fromJson((res));
    }
    notifyListeners();
  }

  /// gets logged in status of user
  Future<bool> get isLoggedIn async {
    final userPrefs = await mainPrefs;
    _isLoggedIn = userPrefs.getBool("isLoggedIn") ?? false;
    // notifyListeners();
    return _isLoggedIn;
  }

  ///sets loggedin status of user
  setLoggedIn(bool status) async {
    final userPrefs = await mainPrefs;
    userPrefs.setBool("isLoggedIn", status);
    if (status == false) setUserID("");
    notifyListeners();
  }

  Future<void> getOfflineUser(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userID = await userProvider.getUserID();
    final userDoc = await FirebaseFirestore.instance
        .collection('user_infos')
        .doc(userID)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data();
      final curUser = MyUser(
        avatar: userData!['avatar'],
        emailAddress: userData['emailAddress'],
        classGroup: userData['classGroup'],
        fullName: userData['fullName'],
        gender: userData['gender'],
        indexNum: userData['indexNum'],
        phoneNum: userData['phoneNum'],
        userLevel: userData['userLevel'],
        userName: userData['userName'],
        isAdmin: userData['isAdmin'] ?? false,
      );

      userProvider.setUser(curUser);
    }
  }

  Future setUserDetails() async {
    final uid = await getUserID();
    final user = FirebaseAuth.instance.currentUser!;
    final userDb = await FirebaseFirestore.instance
        .collection('user_infos')
        .where("userID", isEqualTo: uid)
        .get()
        .then((value) => value.docs[0].data());

    curUser = MyUser(
      avatar: user.photoURL,
      fullName: user.displayName,
      emailAddress: user.email,
      indexNum: int.parse(userDb['indexNum']),
      gender: userDb["gender"],
      userLevel: userDb["userLevel"],
      userName: userDb["userName"],
      classGroup: userDb["classGroup"],
      phoneNum: userDb["phoneNum"],
      isAdmin: userDb["isAdmin"] ?? false,
    );
    // print(curUser!.toJson());

    await setUser(curUser!);
    // notifyListeners();
    // return;
  }

  Future clearUserDetails() async {
    final userPrefs = await mainPrefs;
    userPrefs.clear();
    curUser = null;
    notifyListeners();
  }
}

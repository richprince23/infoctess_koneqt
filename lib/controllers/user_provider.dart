import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoctess_koneqt/models/user_info.dart' as cUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/env.dart';

class UserProvider extends ChangeNotifier {
  int? _indexNum;
  String? _firstName;
  late bool _isLoggedIn;
  late String _userID;

  UserInfo? _userInfo;

  /// gets user's index number
  get indexNum async => _indexNum;

  /// sets user's index number
  setPhoneNum(int? indexNum) async {
    final userPrefs = await mainPrefs;
    _indexNum = indexNum;
    userPrefs.setInt("phoneNum", indexNum!);
    notifyListeners();
  }

  /// gets user's id
  Future<String> getUserID() async => _userID;

  ///sets user's id
  setUserID(String userID) async {
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
  Future<UserInfo?> getUserInfo() async {
    return _userInfo;
  }

  /// sets a userinfo from a UserInfo model
  setUser(cUser.User user) async {
    final userPrefs = await mainPrefs;
    userPrefs.setString('curUser', curUser!.toJson().toString());

    notifyListeners();
  }

  Future getUser() async {
    final userPrefs = await mainPrefs;
    notifyListeners();
    final res = userPrefs.getString("curUser");
    curUser = cUser.User.fromJson(res! as Map<String, dynamic>);
    // return userPrefs.getString("curUser");
  }

  /// gets logged in status of user
  Future<bool> get isLoggedIn async {
    final userPrefs = await mainPrefs;
    _isLoggedIn = userPrefs.getBool("isLoggedIn") ?? false;
    return _isLoggedIn;
  }

  ///sets loggedin status of user
  setLoggedIn(bool status) async {
    final userPrefs = await mainPrefs;
    userPrefs.setBool("isLoggedIn", status);
    notifyListeners();
  }

  Future setUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final userDb = await FirebaseFirestore.instance
        .collection('user_infos')
        .where("userID", isEqualTo: user!.uid)
        .get()
        .then((value) => value.docs[0].data());

    curUser = cUser.User(
      avatar: user.photoURL,
      fullName: user.displayName,
      emailAddress: user.email,
      indexNum: int.parse(userDb['indexNum']),
      gender: userDb["gender"],
      userLevel: userDb["userLevel"],
      userName: userDb["userName"],
      classGroup: userDb["classGroup"],
      phoneNum: userDb["phoneNum"],
    );
  }
}

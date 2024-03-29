import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/user_info.dart';
import 'package:http/http.dart' as http;

class OnboardingController extends ChangeNotifier {
  String _selectedLevel = "";
  String _selectedGroup = "";
  String _selectedGender = "";
  String _fullName = "";
  String _emailAddress = "";
  String _userName = "";
  String _phoneNum = "";
  String _indexNum = "";
  final String _password = "";

  int _curPageIndex = 0;
  int get curPageIndex => _curPageIndex;

  String get selectedLevel => _selectedLevel;
  String get selectedGroup => _selectedGroup;
  String get selectedGender => _selectedGender;
  String get fullName => _fullName;
  String get emailAddress => _emailAddress;
  String get userName => _userName;
  String get phoneNum => _phoneNum;
  String get indexNum => _indexNum;
  String get password => _password;

  set selectedLevel(String level) {
    _selectedLevel = level;
    notifyListeners();
  }

  set selectedGroup(String group) {
    _selectedGroup = group;
    notifyListeners();
  }

  set selectedGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  set curPageIndex(int value) {
    _curPageIndex = value;
    notifyListeners();
  }

  set emailAddress(String value) {
    _emailAddress = value;
    notifyListeners();
  }

  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  set indexNum(String value) {
    _indexNum = value;
    notifyListeners();
  }

  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  set phoneNum(String value) {
    _phoneNum = value;
    notifyListeners();
  }

  set password(String value) {
    password = value;
    notifyListeners();
  }

  void goBack() {
    if (curPageIndex > 0) {
      curPageIndex--;
      pageController.animateToPage(curPageIndex,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      notifyListeners();
    }
  }

  void nextPage() {
    if (curPageIndex < kPages.length - 1) {
      curPageIndex++;
      pageController.animateToPage(curPageIndex,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }
}

Future<int?> checkUserAccess(String indexNum) async {
  var url = Uri.parse('http://api.infoctess-uew.org/members/$indexNum');

  int? res;

  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (response.body.isEmpty || response.body == "[]") {
      // print("Response body is null or empty.");
      res = 0;
      return res;
    }
    //check user here
    await Auth().checkUserExists(indexNum).then((value) {
      if (value == false) {
        onboardUser = MyUser(
          indexNum: int.parse(data['index_num']),
          fullName: "${data['othernames']} ${data['surname']}",
          emailAddress: data['email'] ?? "",
          userLevel: "Level ${data['level']}",
          classGroup: data['groupings'] ?? "",
          gender: data['gender'] ?? "",
          phoneNum: data['contact1'] ?? "",
        );
        //set curUser to onboard
        curUser = onboardUser;
        // return onboardUser;
        // print("User does not exist. Please register.");
        res = 1;
        return res;
      } else {
        // print("User exists. Please login.");
        res = 2;
        return res;
      }
    });
    // onboardUser = User.fromJson(data[0]);
  } else {
    // print("Request failed with status: ${response.statusCode}.");
    res = 500;
    return res;
  }
  return res;
}

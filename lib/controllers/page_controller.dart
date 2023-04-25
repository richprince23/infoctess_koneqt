import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/screens/forums.dart';
import 'package:infoctess_koneqt/screens/home/homepage.dart';
import 'package:provider/provider.dart';

class PageControl extends ChangeNotifier {
  int _pageIndex = 0;

  var kMainPages = <Widget>[
    HomePage(),
    ForumsScreen(),
  ];

  int get pageIndex => _pageIndex;

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}

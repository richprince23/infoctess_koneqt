import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:provider/provider.dart';

class OnboardingController extends ChangeNotifier {
  String _selectedLevel = "";
  String _selectedGroup = "";
  String _selectedGender = "";

  int _curPageIndex = 0;
  int get curPageIndex => _curPageIndex;

  String get selectedLevel => _selectedLevel;
  String get selectedGroup => _selectedGroup;
  String get selectedGender => _selectedGender;

  

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

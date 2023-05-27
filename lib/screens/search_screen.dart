import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:resize/resize.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InputControl(
          showLabel: false,
          isSearch: true,
          hintText: "Search for Posts, Events, News, People, Hastags etc..",
        ),
        toolbarHeight: kToolbarHeight + 40.w,
      ),
      body: Container(
        child: Center(
          child: Text("Search Screen"),
        ),
      ),
    );
  }
}

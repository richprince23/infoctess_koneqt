import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/search_controller.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List searchResults = [];
  List searchResults1 = [];

  Future<void> search(String query) async {
    searchResults.clear();

    // Search for posts from Firebase Firestore
    final posts = await db
        .collection('posts')
        .where('body', isGreaterThanOrEqualTo: query.toLowerCase())
        .get();

    if (posts.docs.isNotEmpty) {
      setState(() {
        searchResults = posts.docs.toList();
      });
      print(searchResults[0].data());
    }
  }

  @override
  void initState() {
    super.initState();
    searchResults = [];
    search("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InputControl(
          controller: _searchController,
          showLabel: false,
          isSearch: true,
          hintText: "Search for Posts, Events, News, People, Hashtags, etc..",
          onChanged: (value) async {
            searchResults1.clear();
            for (var item in searchResults) {
              if (item['body'].toLowerCase().contains(value.toLowerCase())) {
                setState(() {
                  searchResults1.add(item);
                });
                print(searchResults1[0].data());
              }
            }
          },
        ),
        toolbarHeight: kToolbarHeight + 40.w,
      ),
      body: Container(
        child: Center(
          child: buildSearchList(),
        ),
      ),
    );
  }

  Widget buildSearchList() {
    if (searchResults.isNotEmpty) {
      return ListView.builder(
        itemCount: searchResults1.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(searchResults1[index]['body'] + " $index"),
            leading: Icon(Icons.search),
          );
        },
      );
    }
    return Center(
      child: EmptyList(text: "No results found"),
    );
  }
}

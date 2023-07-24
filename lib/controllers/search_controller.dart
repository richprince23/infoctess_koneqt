import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoctess_koneqt/env.dart';

List searchResults = [];
Future search(String query) async {
  searchResults.clear();
  //search for posts from firebase firestore
  await FirebaseFirestore.instance
      .collection('news')
      .where('body'.toLowerCase(), isGreaterThanOrEqualTo: query.toLowerCase())
      .get()
      .then((value) {
    // print("typing");
    if (value.docs.isNotEmpty) {
      for (var post in value.docs) {
        searchResults.add(post);
        // print(searchResults[0].data());
      }
    }
  });

  //search for events from firebase firestore

  //search for news from firebase firestore

  //search for people from firebase firestore

  //search for hashtags from firebase firestore

  return searchResults;
}

/// Add a search term to search history.
///
/// Uses shared Preferences
Future<void> addToHistory({required String searchText}) async {
  final prefs = await mainPrefs;
  List<String>? searchedList = prefs.getStringList("searchHistory");
  searchedList?.insert(0, searchText);
  prefs.setStringList("searchHistory", searchedList!);

  for (var element in searchedList) {
    print(element);
  }
}

/// Returns the search history from a list of Strings in Shared Prefs
///
Future<List<String>?> getSearchHistory() async {
  final prefs = await mainPrefs;
  List<String>? searchedList = prefs.getStringList("searchHistory");
  return searchedList;
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/model_type_enum.dart';

/// return a list of search results from firebase firestore based on the filter
Stream<QuerySnapshot<Map<String, dynamic>>>? setStream(ModelType type) {
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  switch (type) {
    case ModelType.post:
      stream = FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asBroadcastStream();
      return stream;
    case ModelType.news:
      stream = FirebaseFirestore.instance
          .collection('news')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asBroadcastStream();
      return stream;
    case ModelType.event:
      stream = FirebaseFirestore.instance
          .collection('events')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asBroadcastStream();
      return stream;
    case ModelType.people:
      stream = FirebaseFirestore.instance
          .collection('users')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asBroadcastStream();
      return stream;
    default:
      return null;
  }
}

//search for events from firebase firestore

//search for news from firebase firestore

//search for people from firebase firestore

//search for hashtags from firebase firestore

/// Add a search term to search history.
///
/// Uses shared Preferences
Future<void> addToHistory({required String searchText}) async {
  final prefs = await mainPrefs;
  List<String>? searchedList = prefs.getStringList("searchHistory") ?? [];
  searchedList.insert(0, searchText);
  prefs.setStringList("searchHistory", searchedList);
}

/// Returns the search history from a list of Strings in Shared Prefs
///
Future<List<String>?> getSearchHistory() async {
  final prefs = await mainPrefs;
  List<String>? searchedList = prefs.getStringList("searchHistory");
  return searchedList;
}

/// Clear search history
///
Future<void> clearHistory() async {
  final prefs = await mainPrefs;
  await prefs.setStringList("searchHistory", []);
}

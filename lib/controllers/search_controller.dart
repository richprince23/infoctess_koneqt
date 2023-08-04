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
          // .where('body', isGreaterThanOrEqualTo: query)
          .orderBy('body', descending: true)
          .snapshots()
          .asBroadcastStream();
      break;
    case ModelType.news:
      stream = FirebaseFirestore.instance
          .collection('news')
          // .where('title', isGreaterThanOrEqualTo: query)
          .orderBy('title', descending: true)
          .snapshots()
          .asBroadcastStream();
      break;
    case ModelType.event:
      stream = FirebaseFirestore.instance
          .collection('events')
          // .where('title', isGreaterThanOrEqualTo: query)
          .orderBy('title', descending: true)
          .snapshots()
          .asBroadcastStream();
      break;
    case ModelType.people:
      stream = FirebaseFirestore.instance
          .collection('user_infos')
          // .where('fullName', isGreaterThanOrEqualTo: query)
          .orderBy('fullName', descending: true)
          .snapshots()
          .asBroadcastStream();
      break;
    default:
      stream = FirebaseFirestore.instance
          .collection('posts')
          // .where('body', isGreaterThanOrEqualTo: query)
          .orderBy('body', descending: true)
          .snapshots()
          .asBroadcastStream();
      break;
  }
  return stream;
}

//search for events from firebase firestore

//search for news from firebase firestore

//search for people from firebase firestore

//search for hashtags from firebase firestore

/// Add a search term to search history.
///
/// Uses shared Preferences
/// If the search term already exists, it is moved to the top of the list
/// if the list is longer than 10 items, the last item is removed
/// [searchText] is the search term to add to the history
Future<void> addToHistory({required String searchText}) async {
  final prefs = await mainPrefs;
  List<String>? searchedList = prefs.getStringList("searchHistory") ?? [];
  if (searchedList.contains(searchText)) {
    searchedList.remove(searchText);
  }
  if (searchedList.length > 10) {
    searchedList.removeLast();
  }
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

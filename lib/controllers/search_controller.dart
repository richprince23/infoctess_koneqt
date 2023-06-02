import 'package:cloud_firestore/cloud_firestore.dart';

List searchResults = [];
Future search(String query) async {
  searchResults.clear();
  //search for posts from firebase firestore
  final posts = await FirebaseFirestore.instance
      .collection('news')
      .where('body'.toLowerCase(), isGreaterThanOrEqualTo: query.toLowerCase())
      .get()
      .then((value) {
    // print("typing");
    if (value.docs.isNotEmpty) {
      for (var post in value.docs) {
        searchResults.add(post);
        print(searchResults[0].data());
      }
    }
  });

  //search for events from firebase firestore

  //search for news from firebase firestore

  //search for people from firebase firestore

  //search for hashtags from firebase firestore

  return searchResults;
}

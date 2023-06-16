import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/env.dart';

//get user posts
Future getUserPosts({required String userID}) async {
  final posts = await db
      .collection("posts")
      .where("posterID", isEqualTo: userID)
      .get()
      .then((value) {
    return value.docs;
  });
  return posts;
}

//get user shared media
Future getUserSharedMedia({required String userID}) async {
  List media = [];
  final chats = await db
      .collection("chats")
      .where("members", arrayContains: userID)
      .get();

//loop through chats to get a collection of messages with the user
  for (var doc in chats.docs) {
    final members = doc.data()['members'] as List;
    if (members.contains(auth.currentUser!.uid)) {
      //get messages with mediaUrl
      final list = await db
          .collection("chats")
          .doc(doc.id)
          .collection("messages")
          .where("mediaUrl", isNotEqualTo: null)
          .get();
      // .then((value) {
      if (list.docs.isNotEmpty) {
        for (var doc in list.docs) {
          //add mediaUrl to media list
          if (doc.data()['mediaUrl'] != null) {
            media.add(doc.data()['mediaUrl']);
          }
          print("print url ${doc.data()['mediaUrl']}");
        }
      }
      // });
    }
  }

  return media;
}

//Follow user
Future followUser({required String userID}) async {
  try {
    var result;
    await db
        .collection("user_infos")
        .where('userID', isEqualTo: userID)
        .get()
        .then((value) {
      final userFollowers = value.docs[0].data()['following'] as List;
      if (userFollowers.contains(auth.currentUser!.uid)) {
        // Unfollow user
        value.docs[0].reference.update({
          'following': FieldValue.arrayRemove([auth.currentUser!.uid])
        });
        result = "Follow";
      } else {
        // Follow user
        value.docs[0].reference.update({
          'following': FieldValue.arrayUnion([auth.currentUser!.uid])
        });

        result = "Unfollow";
      }
    });
    return result;
  } catch (e) {
    throw Exception(e);
  }
}

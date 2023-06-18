import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';

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

//Provider for user profile
class ProfileProvider extends ChangeNotifier {
  bool _isFollowing = false;
  String _followText = "Follow";
  bool get isFollowing => _isFollowing;

  String get followText => _followText;

  Future<void> checkIfFollowing({required String userID}) async {
    final result = await db
        .collection("user_infos")
        .where('userID', isEqualTo: userID)
        .get()
        .then((value) {
      final userFollowers = value.docs[0].data()['following'] as List;
      if (userFollowers.contains(auth.currentUser!.uid)) {
        _isFollowing = true;
        _followText = "Unfollow";
      } else {
        _isFollowing = false;
        _followText = "Follow";
      }
    });
    notifyListeners();
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
          _isFollowing = false;
          result = "Follow";
        } else {
          // Follow user
          value.docs[0].reference.update({
            'following': FieldValue.arrayUnion([auth.currentUser!.uid])
          });
          _isFollowing = true;
          result = "Unfollow";
        }
      });
      _followText = result;
      notifyListeners();
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  //
  //get poster details
  Future getPosterDetails({required userID, required Poster user}) async {
    final userInfo = await db
        .collection("user_infos")
        .where("userID", isEqualTo: userID)
        .get()
        .then((value) {
      var details = value.docs[0].data();
      user.posterName = details['fullName'];
      user.posterID = details['userID'];
      user.userName = details['userName'];
      user.posterAvatarUrl = details['avatar'];
      user.isPosterAdmin = details['isAdmin'];
    });
    // Future.delayed(const Duration(seconds: 1));
    return userInfo;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/comments_model.dart';
import 'package:infoctess_koneqt/models/poster_model.dart';
import 'package:infoctess_koneqt/models/posts_model.dart';

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
          // print("print url ${doc.data()['mediaUrl']}");
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
    String? result;
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

  final List _followingList = [];
  final List _followersList = [];

  //get following list of current user

  Future<List> getFollowingList() async {
    // List<Poster> following = []; // Updated: Initialize as a List<Poster>
    await db
        .collection("user_infos")
        .where("userID", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) async {
      var user = value.docs[0];
      _followingList.clear();
      for (var element in user.data()['following']) {
        // print(element);
        if (element != auth.currentUser!.uid) {
          _followingList.add(element);
        }
      }
      // print(following.length);
    });
    notifyListeners();
    return _followingList;
  }

  //get followers list of current user
  Future<List> getFollowersList() async {
    // List<Poster> followers = []; // Updated: Initialize as a List<Poster>
    await db
        .collection("user_infos")
        .where("userID", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) async {
      var user = value.docs[0];
      _followersList.clear();
      for (var element in user.data()['followers']) {
        // print(element);
        if (element != auth.currentUser!.uid) {
          _followersList.add(element);
        }
      }
      // print(followers.length);
    });
    notifyListeners();
    return _followersList;
  }

//check if user is following
  Future<void> checkIfFollowing({required String userID}) async {
  await db
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
      String? result;
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
      _followText = result!;
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

  // get user activity like posts, comments,
  Future getUserActivity({required String userID}) async {
    List<Post> postList = [];
    List<Comment> commentList = [];
    List activityList = [];
    final posts =
        await db.collection("posts").where("posterID", isEqualTo: userID).get();
    for (var doc in posts.docs) {
      Post post = Post.fromMap(doc.data());
      postList.add(post);
    }
    final comments = await db
        .collection("comments")
        .where("posterID", isEqualTo: userID)
        .get();
    for (var doc in comments.docs) {
      Comment comment = Comment.fromMap(doc.data());
      commentList.add(comment);
    }
    activityList.addAll(postList);
    activityList.addAll(commentList);
    return activityList;
  }

  //get user posts
  Future<List<Post>> getUserPosts() async {
    List<Post> postList = [];
    final posts = await db
        .collection("posts")
        .where("posterID", isEqualTo: auth.currentUser!.uid)
        .get();
    for (var doc in posts.docs) {
      var p = doc.data();
      Post post = Post(
        id: doc.id,
        body: p['body'],
        posterID: p['posterID'],
        // comments: p['comments'] as List<Comment>,
        imgUrl: p['image'],
        // likes: p['likes'],
        timestamp: p['timestamp'].toDate(),
      );
      postList.add(post);
    }
    return postList;
  }
}

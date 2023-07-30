import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/models/comments_model.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
final postImageRef = storage.ref("posts");
final FirebaseAuth _auth = FirebaseAuth.instance;
UploadTask? task;

Future sendPost(String postText, {String? imagePath}) async {
  final uid = _auth.currentUser!.uid;
  // save image to storage and get url

  if (imagePath != null && imagePath != "") {
    if (File(imagePath).existsSync()) {
      final imageRef =
          postImageRef.child("${DateTime.now().millisecondsSinceEpoch}.jpg");
      task = imageRef.putFile(File(imagePath).absolute);
      imagePath = await (await task!).ref.getDownloadURL();
    }
  }
  try {
    await db.collection("posts").add({
      "body": postText,
      "posterID": uid,
      "timestamp": Timestamp.now(),
      "likes": [],
      "comments": [],
      "image": imagePath,
    });
  } on Exception catch (e) {
    throw Exception(e);
  }
}

Future deletePost(String postID) async {
  try {
    // await db.collection("posts").doc(postID).delete();
    final post = await db.collection("posts").doc(postID).get();
    final postMediaRef = storage.ref("posts");
    final imgUrl = post.data()!['image'];
    //check if post has image
    if (imgUrl != null) {
      await postMediaRef.storage.refFromURL(imgUrl).delete();
    }
    await db.collection("posts").doc(postID).delete();
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

Future sendComment(String commentText, String postID) async {
  final uid = _auth.currentUser!.uid;
  Comment comment = Comment(
    text: commentText,
    authorID: uid,
    timestamp: DateTime.now(),
  );
  try {
    await db.collection("posts").doc(postID).collection("comments").add(
          comment.toJson(),
        );
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

Future sendLike(String postID) async {
  final uid = _auth.currentUser!.uid;
  try {
    // check if user has already liked the post
    final post = await db.collection("posts").doc(postID).get();
    if (post.data()?["likes"].contains(uid)) {
      await db.collection("posts").doc(postID).update({
        "likes": FieldValue.arrayRemove([uid])
      });
      return false;
    }
    await db.collection("posts").doc(postID).update({
      "likes": FieldValue.arrayUnion([uid])
    });
    return true;
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

int getCommentsCount(String postID) {
  int count = 0;
  db
      .collection("posts")
      .doc(postID)
      .collection("comments")
      // .where("postID", isEqualTo: postID)
      .get()
      .then((value) {
    count = value.docs.length;
  });

  return count;
}

int getLikesCount(String postID) {
  int count = 0;
  db.collection("posts").doc(postID).get().then((value) {
    count = value.data()!["likes"].length;
  });
  return count;
}

//count the view
Future countViews(String postID) async {
  List<dynamic>? views = <dynamic>[];
  final postRef = db.collection("posts").doc(postID);
  await postRef.update({
    "views": FieldValue.arrayUnion([auth.currentUser?.uid])
  }).then((value) async => {
        postRef.get().then((value) => {
              views = value.data()?["views"] as List<dynamic>?,
            })
      });
  return views?.length;
}

class Stats extends ChangeNotifier {
  int? _likes = 0;
  int? _comments = 0;
  final int _views = 0;
  bool? _isLiked = false;

  get likes => _likes;
  get comments => _comments;
  get views => _views;
  get isLiked => _isLiked;

  Future setLikes(String postID) async {
    getLikesCount(postID);
    notifyListeners();
  }

  Future setViews(String postID) async {
    countViews(postID);
    notifyListeners();
  }

  Future<int> commentsCount(String docID) async {
    int totalDocuments = 0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("posts")
        .doc(docID)
        .collection('comments')
        .get();
    totalDocuments = querySnapshot.size;
    notifyListeners();
    return totalDocuments;
  }

  Future<int> getLikesCount(String docID) async {
    int totalLikes = 0;
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection("posts").doc(docID).get();
      totalLikes = querySnapshot.data()!['likes'].length;
    } catch (e) {
      debugPrint(e.toString());
    }
    return totalLikes;
  }

  Future getStats(String postID) async {
    commentsCount(postID).then((value) => _comments = value);
    getLikesCount(postID).then((value) => _likes = value);
    checkLike(postID);
    //  _views = countViews(postID);
    notifyListeners();
  }

  Future<bool> checkLike(String postID) async {
    final uid = _auth.currentUser!.uid;
    try {
      // check if user has already liked the post
      final post = await db.collection("posts").doc(postID).get();
      if (post.data()?["likes"].contains(uid)) {
        _isLiked = true;
        notifyListeners();
        return _isLiked!;
      }
      _isLiked = false;
      notifyListeners();
      return _isLiked!;
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}

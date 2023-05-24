import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    await db.collection("posts").doc(postID).update({
      "likes": FieldValue.arrayUnion([uid])
    });
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

int getCommentsCount(String postID) {
  int count = 0;
  db
      .collection("comments")
      .where("postID", isEqualTo: postID)
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

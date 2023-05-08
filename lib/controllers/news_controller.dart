import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:infoctess_koneqt/env.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
final newsImageRef = storage.ref("news");
UploadTask? task;

Future postNews(String title, String body, {String? imagePath}) async {
  final uid = auth.currentUser!.uid;
  // save image to storage and get url
  if (imagePath != null && imagePath != "") {
    if (File(imagePath).existsSync()) {
      final imageRef =
          newsImageRef.child("${DateTime.now().millisecondsSinceEpoch}.jpg");
      task = imageRef.putFile(File(imagePath).absolute);
      imagePath = await (await task!).ref.getDownloadURL();
    }
  }

  try {
    await db.collection("news").add({
      "title": title,
      "body": body,
      "posterID": uid,
      "timestamp": Timestamp.now(),
      "imgUrl": imagePath,
      "likes": 0,
      "comments": [],
    });
  } on Exception catch (e) {
    throw Exception(e);
  }
}

//delete news
Future deleteNews(String postID) async {
  try {
    await db.collection("news").doc(postID).delete();
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

//post comment
Future sendComment(String commentText, String postID) async {
  final uid = auth.currentUser!.uid;
  try {
    await db.collection("news").doc(postID).update({
      "comments": FieldValue.arrayUnion([
        {
          "text": commentText,
          "authorID": uid,
          "timestamp": Timestamp.now(),
        }
      ])
    });
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

//like news post
Future sendLike(String postID) async {
  final uid = auth.currentUser!.uid;
  try {
    await db.collection("news").doc(postID).update({
      "likes": FieldValue.arrayUnion([uid])
    });
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}


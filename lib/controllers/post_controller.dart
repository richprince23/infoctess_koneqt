import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:infoctess_koneqt/controllers/user_provider.dart';
import 'package:provider/provider.dart';

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
  try {
    await db.collection("posts").doc(postID).update({
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

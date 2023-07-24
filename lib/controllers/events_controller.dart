import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:infoctess_koneqt/env.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
final eventsImageRef = storage.ref("events");
UploadTask? task;

Future postNewEvent({
  required String title,
  required String body,
  required String date,
  required String time,
  required String venue,
  required String mode,
  required int fee,
  required String? imagePath,
}) async {
  final uid = auth.currentUser!.uid;
  // save image to storage and get url
  if (imagePath != null && imagePath != "") {
    if (File(imagePath).existsSync()) {
      final imageRef =
          eventsImageRef.child("${DateTime.now().millisecondsSinceEpoch}.jpg");
      task = imageRef.putFile(File(imagePath).absolute);
      imagePath = await (await task!).ref.getDownloadURL();
    }
  }

  try {
    await db.collection("events").add({
      "title": title,
      "body": body,
      "posterID": uid,
      "timestamp": Timestamp.now(),
      "imgUrl": imagePath,
      "venue": venue,
      "date": date,
      "time": time,
      "mode": mode,
      "fee": fee,
      "attendees": [],
    });
  } on Exception catch (e) {
    throw Exception(e);
  }
}

//get events from firestore by date
Future<QuerySnapshot<Map<String, dynamic>>> getEventsByDate(String date) async {
  try {
    return db
        .collection("events")
        .where("date", isEqualTo: date.trim())
        .where("attendees", arrayContains: auth.currentUser!.uid)
        .orderBy("timestamp", descending: true)
        .get();
    // .then((value) => print(value.docs));
    // print(events.docs);
    // return events;
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

//rsvp to event
Future rsvpToEvent(String eventID) async {
  try {
    await db.collection("events").doc(eventID).update({
      "attendees": FieldValue.arrayUnion([auth.currentUser!.uid])
    });
    return true;
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

//unrsvp to event
Future unrsvpToEvent(String eventID) async {
  try {
    await db.collection("events").doc(eventID).update({
      "attendees": FieldValue.arrayRemove([auth.currentUser!.uid])
    });
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

// check if user has rsvp to event
Future<bool> hasUserRsvp(String eventID) async {
  try {
    final event = await db.collection("events").doc(eventID).get();
    final attendees = event.data()!["attendees"];
    return attendees.contains(auth.currentUser!.uid);
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

//delete events
Future deleteEvent(String postID) async {
  try {
    // await db.collection("events").doc(postID).delete();
    final event = await db.collection("events").doc(postID).get();
    //check if event has image
    final eventMediaRef = storage.ref("events");
    final imgUrl = event.data()!['imgUrl'];
    if (imgUrl != null) {
      await eventMediaRef.storage.refFromURL(imgUrl).delete();
    }
    await db.collection("events").doc(postID).delete();
  } on FirebaseException catch (e) {
    throw Exception(e);
  }
}

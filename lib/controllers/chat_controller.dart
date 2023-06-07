//get unread messages

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/env.dart';

final chatMediaRef = storage.ref("chat_media");
UploadTask? task;
final uid = auth.currentUser!.uid;

var unreadMessageList = [];
String? lastMessage;
bool? isRead;
String? lastMessageTime;

Future<void> getLastMessage({required String chatID}) async {
  final QuerySnapshot<Map<String, dynamic>> message = await db
      .collection("chats")
      .doc(chatID)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .limitToLast(1)
      .get();

  if (message.docs.isNotEmpty) {
    lastMessage = message.docs[0].data()['message'];
    isRead = message.docs[0].data()['isRead'];
    lastMessageTime = message.docs[0].data()['timestamp'].toDate().toString();
  } else {
    lastMessage = '';
    isRead = false;
    lastMessageTime = null;
  }

  // print(lastMessageTime);
  await getUnreadMessages(chatID: chatID);
}

//get unread messages
Future getUnreadMessages({required chatID}) async {
  unreadMessageList.clear();
  final QuerySnapshot<Map<String, dynamic>> unreadMessages = await db
      .collection("chats")
      .doc(chatID)
      .collection("messages")
      .where("isRead", isEqualTo: false)
      .get();

  for (var msg in unreadMessages.docs) {
    if (msg.data()['senderID'] != auth.currentUser!.uid) {
      unreadMessageList.add(msg.data());
    }
  }

  return unreadMessages.docs.length;
}

//mark conversation as read

Future markChatAsRead({required String chatID}) async {
  final QuerySnapshot<Map<String, dynamic>> chats =
      await db.collection("chats").doc(chatID).collection("messages").get();

  for (var msg in chats.docs) {
    msg.reference.update({"isRead": true});
  }
}

// send message with attachment
Future sendMessage({
  required String chatID,
  required String message,
  String? attachment,
}) async {
  // save image to storage and get url
  if (attachment != null && attachment != "") {
    if (File(attachment).existsSync()) {
      String fileName = path.basename(attachment).replaceAll(" ", "_");
      fileName = fileName.replaceAll("%", "");

      final imageRef = chatMediaRef
          .child("${DateTime.now().millisecondsSinceEpoch}:$fileName");
      task = imageRef.putFile(File(attachment).absolute);
      attachment = await (await task!).ref.getDownloadURL();
    }
  }

  await db.collection("chats").doc(chatID).collection("messages").add({
    "message": message,
    "mediaUrl": attachment,
    // "attachmentType": attachmentType,
    "senderID": uid,
    "timestamp": DateTime.now(),
    "isRead": false,
  });
}

//delete message

Future deleteMessage(
    {required String chatID, required String messageID}) async {
  if (messageID.isNotEmpty || messageID != "") {
    await db
        .collection("chats")
        .doc()
        .collection("messages")
        .doc(messageID)
        .delete();
    print("message deleted");
  }
}

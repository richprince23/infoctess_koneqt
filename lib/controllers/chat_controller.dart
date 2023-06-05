//get unread messages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/env.dart';

var unreadMessageList = [];
 String? lastMessage;
  bool? isRead;
  String? lastMessageTime;

Future<void> getLastMessage({required String chatID}) async {
    final QuerySnapshot<Map<String, dynamic>> message = await db
        .collection("chats")
        .doc(chatID)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
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

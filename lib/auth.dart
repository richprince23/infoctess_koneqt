import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
final imageRef = storage.ref("images");
final FirebaseAuth _auth = FirebaseAuth.instance;
UploadTask? task;

class Auth {
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // print(e.code);
      // if (e.code == 'user-not-found') {
      //   print('No user found for that email.');
      // } else if (e.code == 'wrong-password') {
      //   print('Wrong password provided for that user.');
      // }
      throw FirebaseAuthException(
        code: e.code,
        message: e.message,
      );
    }

    // return null;
  }

  Future<bool?> checkUserExists(int indexNum) async {
    try {
      await db
          .collection("user_infos")
          .where("indexNum", isEqualTo: indexNum)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          return false;
        } else {
          return true;
        }
      });
    } on FirebaseAuthException catch (e) {
      // print('No user found for that index Number.');
      throw Exception(e);
    }
    return null;
  }

  Future<String?> updateName(String name) async {
    try {
      await _auth.currentUser!.updateDisplayName(name).then((value) => "done");
      return "Update Successful!";
    } on FirebaseAuthException catch (e) {
      // print('No user found for that email.');
      throw Exception(e);
    }
  }

  Future<String?> updateAvatar(String url) async {
    try {
      await _auth.currentUser!.updatePhotoURL(url).then((value) => "done");
      return "Update Successful!";
    } on FirebaseAuthException catch (e) {
      // print('No user found for that email.');
      throw Exception(e);
    }
  }

  Future<String?> saveUserInfo({
    String? indexNum,
    String? level,
    String? gender,
    String? phoneNum,
    String? classGroup,
    String? userName,
  }) async {
    try {
      String? docID;
      await db.collection("user_infos").add({
        "classGroup": classGroup,
        "gender": gender,
        "indexNum": indexNum,
        "phoneNum": phoneNum,
        "userLevel": level,
        "userName": userName,
        "userID": _auth.currentUser!.uid,
      }).then((value) => docID = value.id);
      return docID;
    } catch (e) {
      // throw Exception(e);
      print(e);
    }
  }

  Future saveUserImage(String path) async {
    await imageRef
        .child("avatars/${DateTime.now().millisecondsSinceEpoch}.jpg")
        .putFile(File(path).absolute)
        .then(
      (e) async {
        // return image path
        await e.ref.getDownloadURL().then(
          // store image in db
          (url) async {
            await _auth.currentUser!.updatePhotoURL(url).then(
                  (value) => db
                      .collection("user_infos")
                      .doc(_auth.currentUser!.uid)
                      .update({"avatar": url}),
                );
          },
        );
      },
    );
  }

// Future getAccess(int indexNum) async {
//   // final url = 'https://api.infoctess-uew.org/members/$indexNum';
//   final url = 'http://10.0.2.2:3000/members/$indexNum';
//   final response = await http.get(Uri.parse(url));
//   if (response.statusCode == 200) {
//     if (response.body == 'null') {
//       return null;
//     }
//     print(response.body);
//     return response.body;
//   } else {
//     print('Request failed with status: ${response.statusCode}.');
//   }
// }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        throw Exception(e.message);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw Exception(e.message);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// User? curUser = FirebaseAuth.instance.currentUser;

Future<void> buildChat() async {
  // final user = Provider.of<User>(context);
  // final userDoc = await FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(user.uid)
  //     .get();
  // final userAvatar = userDoc.data()!['avatar'];
  // final chat = Provider.of<Chat>(context);
  // final chatDoc = await FirebaseFirestore.instance
  //     .collection('chats')
  //     .doc(chat.id)
  //     .get();
  // final chatMessages = chatDoc.data()!['messages'];
  // final chatMessagesList = chatMessages as List;
  // final chatMessagesListReversed = chatMessagesList.reversed.toList();
  // final chatMessagesListReversedLength = chatMessagesListReversed.length;
  // final chatMessagesListReversedLengthMinusOne =
  //     chatMessagesListReversedLength - 1;
}

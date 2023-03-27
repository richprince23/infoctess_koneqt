import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future getAccess(int indexNum) async {
    // final url = 'https://api.infoctess-uew.org/members/$indexNum';
    final url = 'http://10.0.2.2:3000/members/$indexNum';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (response.body == 'null') {
        return null;
      }
      print(response.body);
      return response.body;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

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
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
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

User? curUser = FirebaseAuth.instance.currentUser;

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

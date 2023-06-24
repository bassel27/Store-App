import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/constants.dart';
import 'excpetion_handler.dart';

class ChatController with ExceptionHandler {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  Future<void> sendMessage(String message) async {
    await firestoreInstance
        .collection('chats')
        .doc(kMyChatId)
        .collection('messages')
        .add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid
    });
  }
}

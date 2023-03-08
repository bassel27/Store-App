import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/controllers/error_handler.dart';

class ChatController with ErrorHandler {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  Future<void> sendMessage(String message) async {
    await firestoreInstance.collection('chats').doc();
  }
}

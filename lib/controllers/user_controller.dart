import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  get userId {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Map? _userDoc;
  Future<Map> get userDoc async {
    final lol = await db.collection('users').doc(userId).get();
    return _userDoc ?? lol.data() as Map;
  }

  Future<String> getFirstName() async {
    final lol = await userDoc;
    return lol['firstName'];
  }

  Future<String> getLastName() async {
    final lol = await userDoc;
    return lol['lastName'];
  }

  Future<String> getEmail() async {
    final lol = await userDoc;
    return lol['email'];
  }

  Future<bool> isAdmin() async {
    final lol = await userDoc;
    return lol['isAdmin'];
  }
}

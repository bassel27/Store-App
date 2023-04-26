import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  get userId {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Map? _userDoc;
  Future<Map> get userDoc async {
    _userDoc ??= (await db.collection('users').doc(userId).get()).data() as Map;
    return _userDoc!;
  }

  Future<String> getFirstName() async {
    return (await userDoc)['firstName'];
  }

  Future<String> getLastName() async {
    return (await userDoc)['lastName'];
  }

  Future<String> getEmail() async {
    return (await userDoc)['email'];
  }

  Future<bool> isAdmin() async {
    return (await userDoc)['isAdmin'];
  }
}

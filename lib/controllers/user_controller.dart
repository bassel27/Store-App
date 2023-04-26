import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/address/address.dart';

class UserController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  get userId {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  late final userDoc = db.collection('users').doc(userId);
  Map? _userDocData;
  Future<Map> get userDocData async {
    _userDocData ??= (await userDoc.get()).data() as Map;
    return _userDocData!;
  }

  Future<String> getFirstName() async {
    return (await userDocData)['firstName'];
  }

  Future<String> getLastName() async {
    return (await userDocData)['lastName'];
  }

  Future<String> getEmail() async {
    return (await userDocData)['email'];
  }

  Future<bool> isAdmin() async {
    return (await userDocData)['isAdmin'];
  }

  Future<void> postAddress(Address address) async {
    await userDoc.update({'address':address.toJson()});
  }
}

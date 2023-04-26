import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:store_app/models/user/user.dart';

import '../models/address/address.dart';

class UserController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  get userId {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<User> get() async {
    _userDocData = (await userDoc.get()).data() as Map<String, dynamic>;
    return User.fromJson(_userDocData);
  }

  get userDoc {
    return db.collection('users').doc(userId);
  }

  late Map<String, dynamic> _userDocData;

  Future<void> postAddress(Address address) async {
    await userDoc.update({'address': address.toJson()});
  }
}

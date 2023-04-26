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
    return User.fromJson(await userDocData);
  }

  late final userDoc = db.collection('users').doc(userId);
  Map<String, dynamic>? _userDocData;
  Future<Map<String, dynamic>> get userDocData async {
    _userDocData ??= (await userDoc.get()).data() as Map<String, dynamic>;
    return _userDocData!;
  }

  Future<void> postAddress(Address address) async {
    await userDoc.update({'address': address.toJson()});
  }
}

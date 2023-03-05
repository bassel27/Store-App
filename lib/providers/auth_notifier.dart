import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:store_app/controllers/auth_controller.dart';
import 'package:store_app/controllers/error_handler.dart';

class AuthNotifier with ChangeNotifier, ErrorHandler {
  final authControler = AuthController();

  DateTime? _expiryDate;
  Timer? _authTimer;
  final _auth = FirebaseAuth.instance;

  bool isDateNotReached(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  Future<void> signup(String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({'email': email});
    } on PlatformException catch (e) {
      handleError(e);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on PlatformException catch (e) {
      handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on PlatformException catch (e) {
      handleError(e);
    }
  }
}

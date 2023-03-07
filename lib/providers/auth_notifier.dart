import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, UserCredential;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/controllers/auth_controller.dart';
import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/models/user/user.dart';

class AuthNotifier with ChangeNotifier, ErrorHandler {
  final authControler = AuthController();

  DateTime? _expiryDate;
  Timer? _authTimer;
  final _auth = FirebaseAuth.instance;

  bool isDateNotReached(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  void _wrapInTryCatch(Function foo, [showLoading = false]) async {
    if (showLoading) {
      DialogHelper.showLoading();
    }
    try {
      await foo();
      if (showLoading) {
        DialogHelper.hideCurrentDialog();
      }
    } on PlatformException catch (e) {
      handleException(e);
    } on FirebaseAuthException catch (e) {
      handleException(e);
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> sendVerificationEmail() async {
    await _auth.currentUser!.sendEmailVerification();
  }

  Future<void> signup(User user) async {
    DialogHelper.showLoading();
    UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: user.email.trim(), password: user.password);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user!.uid)
        .set(user.toJson());
    DialogHelper.hideCurrentDialog();
  }

  Future<void> login(String email, String password) async {
    DialogHelper.showLoading();
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      DialogHelper.hideCurrentDialog();
    } on PlatformException catch (e) {
      handleException(e);
    } on FirebaseAuthException catch (e) {
      handleException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on PlatformException catch (e) {
      handleException(e);
    } on FirebaseAuthException catch (e) {
      handleException(e);
    }
  }
}

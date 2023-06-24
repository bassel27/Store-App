import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, UserCredential;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models/user/user.dart';
import '../../domain/usecases/auth_controller.dart';
import '../../domain/usecases/excpetion_handler.dart';
import '../mixins/try_catch_firebase.dart';
import '../widgets/dialog_helper.dart';

class AuthNotifier
    with ChangeNotifier, ExceptionHandler, TryCatchFirebaseWrapper {
  final authControler = AuthController();

  final _auth = FirebaseAuth.instance;

  bool isDateNotReached(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      handleException(e);
    }
  }

  Future<void> signup(User user) async {
    DialogHelper.showLoading();
    UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: user.email.trim(), password: user.password!);
    String generatedUserId = authResult.user!.uid;
    user = user.copyWith(id: generatedUserId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(generatedUserId)
        .set(user.toJson());
    DialogHelper.hideCurrentDialog();
  }

  Future<void> login(String email, String password) async {
    DialogHelper.showLoading();
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      DialogHelper.hideCurrentDialog();
    } on PlatformException catch (e) {
      handleException(e);
    } on FirebaseAuthException catch (e) {
      handleException(e);
    }
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}

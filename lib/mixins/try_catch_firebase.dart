import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../controllers/excpetion_handler.dart';
import '../helper/dialog_helper.dart';

mixin TryCatchFirebaseWrapper {
  Future<void> wrapInTryCatch(Future<void> Function() foo,
      [showLoading = false]) async {
    if (showLoading) {
      DialogHelper.showLoading();
    }
    try {
      await foo();
      if (showLoading) {
        DialogHelper.hideCurrentDialog();
      }
    } on PlatformException catch (e) {
      ExceptionHandler().handleException(e);
    } on FirebaseAuthException catch (e) {
      ExceptionHandler().handleException(e);
    }
  }
}

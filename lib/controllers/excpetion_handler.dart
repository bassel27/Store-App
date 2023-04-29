import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/widgets/exception_scaffold_body.dart';

class ExceptionHandler {
  /// Handles exceptions and shows error dialog.
  Widget? handleException(exception, [returnScaffold = false]) {
    DialogHelper.hideCurrentDialog(); // If loading dialog was open
    if (returnScaffold) {
      return ExceptionScaffoldBody(exception);
    } else {
      if (exception is FirebaseAuthException &&
          exception.code == "too-many-requests") {
        // ignore
        return null;
      } else {
        DialogHelper.showErroDialog(
            description: exception.message ?? exception.toString());
      }
    }
    return null;
  }
}

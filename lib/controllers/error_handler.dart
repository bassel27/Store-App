import 'package:flutter/material.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/widgets/exception_scaffold_body.dart';

class ErrorHandler {
  /// Handles exceptions and shows error dialog.
  Widget? handleException(exception, [returnScaffold = false]) {
    DialogHelper.hideCurrentDialog(); // If loading dialog was open
    if (returnScaffold) {
      return ExceptionScaffoldBody(exception);
    } else {
      DialogHelper.showErroDialog(
          description: exception.message ?? exception.toString());
    }
    return null;
  }
}

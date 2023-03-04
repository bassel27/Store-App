import 'package:flutter/services.dart';
import 'package:store_app/helper/dialog_helper.dart';

class ErrorHandler {
  /// Handles exceptions and shows error dialog.
  void handleError(error) {
    DialogHelper.hideCurrentDialog(); // If loading dialog was open
    // if (error is BadRequestException ||
    //     error is FetchDataException ||
    //     error is ApiNotRespondingException) {
    //   DialogHelper.showErroDialog(description: error.message);
    // } else {
    DialogHelper.showErroDialog(
        description:
            error is PlatformException ? error.message : error.toString());
    // }
  }
}

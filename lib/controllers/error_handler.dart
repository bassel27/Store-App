import 'package:store_app/helper/dialog_helper.dart';

import '../services/app_exception.dart';

class ErrorHandler {
  /// Handles exceptions and shows error dialog.
  void handleError(error) {
    DialogHelper.hideCurrentDialog(); // If loading dialog was open
    if (error is BadRequestException ||
        error is FetchDataException ||
        error is ApiNotRespondingException ||
        error is HttpException) {
      DialogHelper.showErroDialog(description: error.message);
    } else {
      DialogHelper.showErroDialog(
          description: 'An error occurred. Contact system administrator');
    }
  }
}

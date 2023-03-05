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
    print(error.message + "and " + error.toString());
    print(error.runtimeType);
    DialogHelper.showErroDialog(description: error.message ?? error.toString());
    // }
  }
}

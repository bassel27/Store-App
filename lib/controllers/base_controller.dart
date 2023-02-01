import 'package:store_app/helper/dialog_helper.dart';

import '../services/app_exception.dart';

/// Handles exceptions.
class BaseController {
  void handleError(error) {
    DialogHelper.hideCurrentDialog();
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErroDialog(
          description:
              'Oops! It took longer to respond. Check your internet connection and try again.');
    }
  }
}

import 'package:store_app/helper/dialog_helper.dart';

import '../services/app_exception.dart';

/// Handles exceptions.
class BaseController {
  void handleError(error) {
    DialogHelper.hideCurrentDialog(); // If loading dialog was open
    if (error is BadRequestException) {
      DialogHelper.showErroDialog(description: error.message);
    } else if (error is FetchDataException) {
      DialogHelper.showErroDialog(description: error.message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErroDialog(
          description:
              'Oops! It took longer to respond. Check your internet connection and try again.');
    }
  }
}

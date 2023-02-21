import 'package:store_app/models/constants.dart';
import 'package:store_app/services/app_exception.dart';

import '../services/base_client.dart';

class AuthController {
  // TODO: change dynamic to map?

  /// Returns decoded response.
  Future<dynamic> signup(String email, String password) async {
    var decodedResponse = await BaseClient.post(kSignUpUrl,
        {'email': email, 'password': password, 'returnSecureToken': true});
    checkIfAuthenticatedCorrectly(decodedResponse);
    return decodedResponse;
  }

  /// Returns decoded response.
  Future<dynamic> login(String email, String password) async {
    var decodedResponse = await BaseClient.post(kLoginUrl,
        {'email': email, 'password': password, 'returnSecureToken': true});
    checkIfAuthenticatedCorrectly(decodedResponse);
    return decodedResponse;
  }

  void checkIfAuthenticatedCorrectly(Map<dynamic, dynamic> responseMap) {
    // only for firebase
    if (responseMap['error'] != null) {
      String error = responseMap['error']['message'];
      if (error.toString().contains('EMAIL_EXISTS')) {
        throw EmailAlreadyExistsException();
      } else if (error.toString().contains('INVALID_EMAIL')) {
        throw InvalidEmailException();
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        throw WeakPasswordException();
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        throw EmailNotFound();
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        throw InvalidPasswordException();
      }
    }
  }
}

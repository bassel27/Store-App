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
    if (responseMap['error'] != null) {
      throw HttpException(responseMap['error']['message']);
    }
  }
}

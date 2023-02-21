import 'package:store_app/models/constants.dart';
import 'package:store_app/services/app_exception.dart';

import '../services/base_client.dart';

class AuthenticationController {
  Future<void> signup(String email, String password) async {
    checkIfAuthenticatedCorrectly(await BaseClient.post(kSignUpUrl,
        {'email': email, 'password': password, 'returnSecureToken': true}));
  }

  Future<void> login(String email, String password) async {
    checkIfAuthenticatedCorrectly(await BaseClient.post(kLoginUrl,
        {'email': email, 'password': password, 'returnSecureToken': true}));
  }

  void checkIfAuthenticatedCorrectly(Map<dynamic, dynamic> responseMap) {
    if (responseMap['error'] != null) {
      throw HttpException(responseMap['error']['message']);
    }
  }
}

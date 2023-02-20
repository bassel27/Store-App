import 'package:store_app/models/constants.dart';

import '../services/base_client.dart';

class AuthenticationController {
  Future<void> signup(String email, String password) async {
    await BaseClient.post(kSignUpUrl,
        {'email': email, 'password': password, 'returnSecureToken': true});
  }

  Future<void> login(String email, String password) async {
    await BaseClient.post(kLoginUrl,
        {'email': email, 'password': password, 'returnSecureToken': true});
  }
}

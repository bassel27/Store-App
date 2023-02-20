import 'package:store_app/models/constants.dart';

import '../services/base_client.dart';

class AuthenticationController {
  Future<void> signup(String email, String password) async {
    print(await BaseClient.post(kSignUpUrl,
        {'email': email, 'password': password, 'returnSecureToken': true}));
  }
}

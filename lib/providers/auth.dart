import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/authentication_controller.dart';

class Auth with ChangeNotifier {
  final authControler = AuthenticationController();
  // String _token;
  // DateTime _expiryDate;
  // String _userId;

  Future<void> signup(String email, String password) async {
    await authControler.signup(email, password);
  }

  Future<void> login(String email, String password) async {
    await authControler.login(email, password);
  }
}

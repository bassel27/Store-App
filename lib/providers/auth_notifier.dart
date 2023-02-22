import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/auth_controller.dart';

class AuthNotifier with ChangeNotifier {
  final authControler = AuthController();
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId!;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    var decodedResponse = await authControler.signup(email, password);
    _token = decodedResponse['idToken'];
  }

  Future<void> login(String email, String password) async {
    var decodedResponse = await authControler.login(email, password);
    _token = decodedResponse['idToken'];
    _userId = decodedResponse['localId'];
    _expiryDate = DateTime.now()
        .add(Duration(seconds: int.parse(decodedResponse['expiresIn'])));
    autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}

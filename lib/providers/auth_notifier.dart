import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        isDateNotReached(_expiryDate!) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  bool isDateNotReached(DateTime date) {
    return date.isAfter(DateTime.now());
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
    autoLogoutAfterExpiryDate();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'userId': _userId,
      'expiryDate': _expiryDate!.toIso8601String(),
      'token': _token,
    }); // json is always a string
    prefs.setString('userData', userData);
  }

  /// Returns true if user succesfully logged in.
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extracteduserData = json.decode(prefs.getString('userData')!);
    final expiryDate =
        DateTime.parse(extracteduserData['expiryDate'] as String);
    if (!isDateNotReached(expiryDate)) {
      return false;
    }
    _token = extracteduserData['token'];
    _userId = extracteduserData['userId'];
    _expiryDate = expiryDate;
    autoLogoutAfterExpiryDate();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  /// Automatically log out after token expires.
  void autoLogoutAfterExpiryDate() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}

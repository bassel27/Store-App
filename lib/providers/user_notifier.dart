import 'package:flutter/foundation.dart';
import 'package:store_app/controllers/user_controller.dart';
import 'package:store_app/models/user/user.dart';

class UserNotifier with ChangeNotifier {
  User? currentUser;
  final UserController _userController = UserController();
  Future<void>fetchCurrentUser() async {
    currentUser = User(
        email: await _userController.getEmail(),
        firstName: await _userController.getFirstName(),
        lastName: await _userController.getLastName(),
        id: _userController.userId, isAdmin: await _userController.isAdmin(),);
  }
}

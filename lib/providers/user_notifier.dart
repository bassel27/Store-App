import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store_app/controllers/excpetion_handler.dart';
import 'package:store_app/controllers/user_controller.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/models/address/address.dart';
import 'package:store_app/models/user/user.dart';

class UserNotifier with ChangeNotifier, ExceptionHandler {
  User? currentUser;
  final UserController _userController = UserController();
  Future<void> getAndSetCurrentUser() async {
    currentUser = await _userController.get();
  }

  Future<void> postAddress(Address address) async {
    DialogHelper.showLoading();
    try {
      await _userController.postAddress(address).then((_) {
        currentUser = currentUser!.copyWith(address: address);
      });
    } catch (e) {
      handleException(e);
    }
    DialogHelper.hideCurrentDialog();
    notifyListeners();
  }

  Future<void> deleteCurrentUser() async {
    await _userController.deleteCurrentUser();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/models/address/address.dart';
import '../../data/models/user/user.dart';
import '../../domain/usecases/excpetion_handler.dart';
import '../../domain/usecases/user_controller.dart';
import '../widgets/dialog_helper.dart';


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

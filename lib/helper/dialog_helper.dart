import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/constants.dart';

class DialogHelper {
  static void showErroDialog(
      {String title = 'Error', String? description = kErrorMessage}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headline4,
              ),
              Text(
                description ?? '',
                style: Get.textTheme.headline6,
              ),
              ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showLoading([String? message]) {
    Future.delayed(
        //
        Duration.zero,
        () => Get.dialog(
              Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 8),
                      Text(message ?? 'Loading...'),
                    ],
                  ),
                ),
              ),
            ));
  }

  /// Hides loading or error dialog.
  static void hideCurrentDialog() {
    if (Get.isDialogOpen!) Get.back();
  }
}

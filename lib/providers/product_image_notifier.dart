import 'dart:io';

import 'package:flutter/cupertino.dart';

/// For EditProductScreen
class ProductImageNotifier with ChangeNotifier {
  File? imageFile;
  dynamic _image;
  set image(dynamic image) {
    _image = image;
    notifyListeners();
  }

  dynamic get image {
    return _image;
  }
}

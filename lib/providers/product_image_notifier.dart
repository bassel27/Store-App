import 'dart:io';

import 'package:flutter/cupertino.dart';

/// For EditProductScreen
class ProductImageNotifier with ChangeNotifier {
  File? imageFile;
  Image? _image;
  set image(Image? image) {
    _image = image;
    notifyListeners();
  }

  Image? get image {
    return _image;
  }
}

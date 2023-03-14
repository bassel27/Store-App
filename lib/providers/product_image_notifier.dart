import 'package:flutter/cupertino.dart';

/// For EditProductScreen
class ProductImageNotifier with ChangeNotifier {
  Image? _image;
  set image(Image? image) {
    _image = image;
    notifyListeners();
  }

  Image? get image {
    return _image;
  }
}

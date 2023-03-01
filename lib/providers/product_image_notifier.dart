import 'package:flutter/cupertino.dart';

enum ImageSrc { gallery, camera, textfield }

/// For EditProductScreen
class ProductImageNotifier with ChangeNotifier {
  Image? _image;
  ImageSrc? imageSource;
  set image(Image? image) {
    _image = image;
    notifyListeners();
  }

  Image? get image {
    return _image;
  }
}

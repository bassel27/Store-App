import 'package:flutter/cupertino.dart';
import 'package:store_app/models/product/product.dart';

class SizeNotifier with ChangeNotifier {
  String? _currentlySelectedSize;
  Product? _product;
  SizeNotifier();
  set product(Product product) {
    _currentlySelectedSize = product.sizeQuantity.keys.toList().first;
  }

  String get currentlySelectedSize {
    return _currentlySelectedSize!;
  }

  set currentlySelectedSize(String size) {
    _currentlySelectedSize = size;
    notifyListeners();
  }
}

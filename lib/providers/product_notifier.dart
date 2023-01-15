import 'package:flutter/material.dart';
import 'package:store_app/models/product.dart';

class ProductNotifier with ChangeNotifier {
  final Product _product;
  ProductNotifier(this._product);
  void toggleFavoriteStatus() {
    _product.isFavorite = !_product.isFavorite;
    notifyListeners();
  }

  get isFavorite {
    return _product.isFavorite;
  }
}

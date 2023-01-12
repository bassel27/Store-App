import 'package:flutter/material.dart';

// TODO: private???????
class Product with ChangeNotifier {
  final String _id;
  final String _title;
  final String _description;
  final double _price;
  final String _imageUrl;
  bool isFavorite;

  Product(
      {required String id,
      required String title,
      required String description,
      required double price,
      required String imageUrl,
      this.isFavorite = false})
      : _id = id,
        _title = title,
        _description = description,
        _price = price,
        _imageUrl = imageUrl;

  get id {
    return _id;
  }

  get title {
    return _title;
  }

  get description {
    return _description;
  }

  get price {
    return _price;
  }

  get imageUrl {
    return _imageUrl;
  }

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

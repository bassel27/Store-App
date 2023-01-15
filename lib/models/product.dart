import 'package:flutter/material.dart';

class Product {
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
      isFavorite = false})
      : _id = id,
        _title = title,
        _description = description,
        _price = price,
        _imageUrl = imageUrl,
        isFavorite = isFavorite;

  get id => _id;

  get title => _title;

  get description => _description;

  get price => _price;

  get imageUrl => _imageUrl;
}

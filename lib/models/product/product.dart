import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String title,
    required String? description, // TODO: remove required
    required String id,
    required double price,
    @Default(false) @JsonKey(ignore: true) bool isFavorite,
    String? imageUrl, 
  }) = _Product;
  
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}


import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const route = 'productDetail';
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
    );
  }
}

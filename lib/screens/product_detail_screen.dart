import 'package:flutter/material.dart';

import '../providers/productNotifier.dart';

class ProductDetailScreen extends StatelessWidget {
  static const route = 'productDetail';
  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)!.settings.arguments as ProductNotifier;
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/product/product.dart';

class ProductCircleAvatar extends StatelessWidget {
  const ProductCircleAvatar({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return CircleAvatar(
        radius: constraints.maxHeight / 2,
        backgroundImage: NetworkImage(product.imageUrl),
      );
    });
  }
}

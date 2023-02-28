import 'package:flutter/material.dart';
import 'package:store_app/models/constants.dart';

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
      return ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: FadeInImage.assetNetwork(
          placeholder: kPlaceHolder,
          fit: BoxFit.cover,
          image: product.imageUrl,
        ),
      );
    });
  }
}

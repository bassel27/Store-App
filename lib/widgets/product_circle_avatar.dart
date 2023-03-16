import 'package:flutter/material.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/widgets/my_cached_network_image.dart';

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
      return SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: MyCachedNetworkImage(product.imageUrl!),
        ),
      );
    });
  }
}

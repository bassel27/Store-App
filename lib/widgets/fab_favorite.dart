import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/widgets/product_grid_tile.dart';

import '../models/product/product.dart';
import '../providers/products_notifier.dart';

class FABFavorite extends StatelessWidget {
  Product product;
  final double circleDiameter;
  FABFavorite(this.product, this.circleDiameter);
  @override
  Widget build(BuildContext context) {
    final ProductsNotifier productsProvider = context.watch<ProductsNotifier>();
    return !productsProvider.products.contains(product)
        ? Container()
        : Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.symmetric(
                vertical: kPhotoPadding + 9, horizontal: kPhotoPadding + 7),
            width: circleDiameter,
            height: circleDiameter,
            child: RawMaterialButton(
              fillColor: Theme.of(context).colorScheme.primary,
              shape: const CircleBorder(),
              onPressed: () =>
                  productsProvider.determineFavoriteStatus(product),
              child: Icon(
                size: circleDiameter / 1.35,
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/controllers/excpetion_handler.dart';
import 'package:store_app/models/constants.dart';

import '../models/product/product.dart';
import '../providers/products_notifier.dart';

class FABFavorite extends StatefulWidget {
  final double circleDiameter;
  const FABFavorite(this.productId, this.circleDiameter);
  final String productId;
  @override
  State<FABFavorite> createState() => _FABFavoriteState();
}

class _FABFavoriteState extends State<FABFavorite> with ExceptionHandler {
  @override
  Widget build(BuildContext context) {
    final ProductsNotifier productsProvider = context.watch<ProductsNotifier>();
    Product? product;
    if (productsProvider.products.any(
      (element) => element.id == widget.productId,
    )) {
      product = productsProvider.products.singleWhere(
        (element) => element.id == widget.productId,
      );
    }

    return product == null
        ? Container()
        : Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.symmetric(
                vertical: kPhotoPadding + 9, horizontal: kPhotoPadding + 7),
            width: widget.circleDiameter,
            height: widget.circleDiameter,
            child: RawMaterialButton(
              fillColor: Theme.of(context).colorScheme.primary,
              shape: const CircleBorder(),
              onPressed: () async {
                await productsProvider
                    .determineFavoriteStatus(product!)
                    .then((value) {
                  setState(() {});
                }).catchError(handleException);
              },
              child: Icon(
                size: widget.circleDiameter / 1.35,
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          );
  }
}

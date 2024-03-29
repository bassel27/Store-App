import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../data/models/constants.dart';
import '../../data/models/product/product.dart';
import '../pages/product_details_screen.dart';
import 'fab_favorite.dart';
import 'my_cached_network_image.dart';

const double kRoundedEdgeRadius = 22;

class ProductGridTile extends StatelessWidget {
  final Product product;
  const ProductGridTile(this.product);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailsScreen.route, arguments: product);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRoundedEdgeRadius),
          ),
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              _ImageAndFavoriteStack(
                  product: product, constraints: constraints),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        product.title,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Text(
                            '$kCurrency ',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                          ),
                          Text(
                            '${product.price.toStringAsFixed(2).endsWith('00') ? Decimal.parse(product.price.toDouble().toInt().toString()) : product.price}',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              // Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 14.0),
              //     child: Align(
              //         alignment: Alignment.centerLeft,
              //         child: AutoSizeText(
              //           product.title,
              //           maxLines: 1,
              //           style: Theme.of(context).textTheme.bodyText2!.copyWith(
              //               fontWeight: FontWeight.w700, fontSize: 18),
              //         ))),
              // const SizedBox(height: 2),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 14.0),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: CurrencyAndPriceText(price: product.price),
              //   ),
              // ),
              // Expanded(
              //   child: Consumer<CartNotifier>(
              //       builder: (context, cartProvider, child) {
              //     CartItem? cartItem = cartProvider.getCartItem(product);
              //     return AnimatedSwitcher(
              //       transitionBuilder: (child, animation) =>
              //           ScaleTransition(scale: animation, child: child),
              //       duration: const Duration(milliseconds: 300),
              //       switchInCurve: Curves.decelerate,
              //       child: cartItem != null
              //           ? _ChangeQuantityRow(
              //               cartItem: cartItem, product: product)
              //           : Center(
              //               child: _MyIconButton(
              //                 Icons.shopping_cart_outlined,
              //                 () {
              //                   cartProvider.add(product);
              //                 },
              //               ),
              //             ),
              //     );
              //   }),
              // ),
              // const SizedBox(
              //   height: 6,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageAndFavoriteStack extends StatelessWidget {
  const _ImageAndFavoriteStack({
    Key? key,
    required this.product,
    required this.constraints,
  }) : super(key: key);

  final Product product;
  final constraints;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: product.id,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: kPhotoPadding, left: kPhotoPadding, right: kPhotoPadding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kRoundedEdgeRadius),
              child: SizedBox(
                height: constraints.maxHeight * 0.77,
                width: double.infinity,
                child: MyCachedNetworkImage(product.imageUrl!),
              ),
            ),
          ),
          FABFavorite(product.id, 30)
          // child is a reference to the Consumer's child property which doesn't rebuild
        ],
      ),
    );
  }
}

class _MyIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;

  const _MyIconButton(this.iconData, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 28,
      iconSize: 33,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.only(top: 2, bottom: 0),
      onPressed: onPressed,
      icon: Icon(iconData),
    );
  }
}

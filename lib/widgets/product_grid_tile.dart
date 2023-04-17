import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/screens/product_details_screen.dart';
import 'package:store_app/widgets/my_cached_network_image.dart';

import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';
import 'fab_favorite.dart';

const double kRoundedEdgeRadius = 22;
const double kPhotoPadding = 9;

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
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: product.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        TextSpan(
                          text: "\n${product.price}",
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
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
    return Stack(
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
              child: Hero(
                tag: product.id,
                child: MyCachedNetworkImage(product.imageUrl!),
              ),
            ),
          ),
        ),

        FABFavorite(product)
        // child is a reference to the Consumer's child property which doesn't rebuild
      ],
    );
  }
}

class _ChangeQuantityRow extends StatelessWidget {
  const _ChangeQuantityRow({
    Key? key,
    required this.cartItem,
    required this.product,
  }) : super(key: key);

  final CartItem cartItem;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final CartNotifier cartProvider = Provider.of<CartNotifier>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(
          width: 10,
        ),
        _MyIconButton(Icons.remove_circle, () {
          cartProvider.decrementQuantity(cartItem);
        }),
        Text(
          cartItem.quantity.toString(),
        ),
        _MyIconButton(Icons.add_circle, () {
          cartProvider.add(product);
        }),
        const SizedBox(
          width: 10,
        ),
      ],
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

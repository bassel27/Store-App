import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/cart_item.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import 'package:store_app/widgets/text_aligned_left.dart';

import '../models/product.dart';
import '../providers/product_notifier.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  const ProductGridTile(this.product);

  @override
  Widget build(BuildContext context) {
    final CartNotifier cartProvider = Provider.of<CartNotifier>(
        context); // you only add to the cart in this widget so there's no need to lsiten
    CartItem? cartItem = cartProvider.items[product.id];

    return LayoutBuilder(
      builder: (ctx, constraints) => GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.route, arguments: product);
        },
        child: Card(
          child: Column(children: [
            _ImageAndFavoriteStack(product: product, constraints: constraints),
            const SizedBox(height: 10),
            TextAlignedLeft(product.name),
            const SizedBox(height: 2),
            TextAlignedLeft("EGP ${product.price.toString()}"),
            cartItem != null
                ? _ChangeQuantityRow(
                    cartProvider: cartProvider,
                    cartItem: cartItem,
                    product: product)
                : IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      cartProvider.addItem(
                          product.id, product.name, product.price);
                    },
                  ),
          ]),
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
        SizedBox(
          height: constraints.maxHeight * 0.5,
          width: double.infinity,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Consumer<ProductNotifier>(
            // this is the only part that will get rebuilt because this is what we need to change. Everything else doesn't change. Listen is always true in consumer another way to rebuild this part only is to place the following widgets in a separate file and use Provider.of(context) such that this file rebuilds itself without affecting the rest. // With consumer, you can split your widget such that only the part in the builder gets rebuilt
            builder: (context, productProvider, _) =>
                _MyFloatingActionButton(productProvider)
            // child is a reference to the Consumer's child property which doesn't rebuild
            ),
      ],
    );
  }
}

class _ChangeQuantityRow extends StatelessWidget {
  const _ChangeQuantityRow({
    Key? key,
    required this.cartProvider,
    required this.cartItem,
    required this.product,
  }) : super(key: key);

  final CartNotifier cartProvider;
  final CartItem cartItem;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              cartProvider.removeSingleItem(cartItem.id);
            },
            icon: const Icon(Icons.remove_circle)),
        Text(
          cartItem.quantity.toString(),
        ),
        IconButton(
            onPressed: () {
              cartProvider.addItem(product.id, product.name, product.price);
            },
            icon: const Icon(Icons.add_circle))
      ],
    );
  }
}

class _MyFloatingActionButton extends StatelessWidget {
  final ProductNotifier productProvider;
  const _MyFloatingActionButton(this.productProvider);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, right: 7),
      width: 25,
      height: 25,
      child: RawMaterialButton(
        fillColor: kSecondaryColor,
        shape: const CircleBorder(),
        onPressed: productProvider.toggleFavoriteStatus,
        child: Icon(
          size: 20,
          productProvider.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: kAccentColor,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/cart_item.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import 'package:store_app/widgets/text_aligned_left.dart';

import '../models/product.dart';
import '../providers/products_notifier.dart';
import 'currency_and_price_text.dart';

double kPaddingValue = 50;

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
          elevation: 5,
          child: Column(
            children: [
              _ImageAndFavoriteStack(
                  product: product, constraints: constraints),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: TextAlignedLeft(product.title),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CurrencyAndPriceText(price: product.price),
                ),
              ),
              Expanded(
                child: cartItem != null
                    ? _ChangeQuantityRow(
                        cartProvider: cartProvider,
                        cartItem: cartItem,
                        product: product)
                    : _MyIconButton(
                        Icons.shopping_cart,
                        () {
                          cartProvider.addItem(
                              product.id, product.title, product.price);
                        },
                      ),
              ),
              const SizedBox(
                height: 6,
              )
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
        SizedBox(
          height: constraints.maxHeight * 0.55,
          width: double.infinity,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Consumer<ProductsNotifier>(
            // this is the only part that will get rebuilt because this is what we need to change. Everything else doesn't change. Listen is always true in consumer another way to rebuild this part only is to place the following widgets in a separate file and use Provider.of(context) such that this file rebuilds itself without affecting the rest. // With consumer, you can split your widget such that only the part in the builder gets rebuilt
            builder: (context, productsProvider, _) =>
                _MyFloatingActionButton(productsProvider, product)
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
  removeOne() {
    cartProvider.removeSingleItem(cartItem.id);
  }

  addOne() {
    cartProvider.addItem(product.id, product.title, product.price);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(
          width: 10,
        ),
        _MyIconButton(Icons.remove_circle, removeOne),
        Text(
          cartItem.quantity.toString(),
        ),
        _MyIconButton(Icons.add_circle, addOne),
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

class _MyFloatingActionButton extends StatelessWidget {
  final ProductsNotifier productsProvider;
  final Product product;
  const _MyFloatingActionButton(this.productsProvider, this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, right: 7),
      width: 25,
      height: 25,
      child: RawMaterialButton(
        fillColor: Theme.of(context).colorScheme.secondary,
        shape: const CircleBorder(),
        onPressed: ()  =>
             productsProvider.toggleFavoriteStatus(product),
        child: Icon(
          size: 20,
          product.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}

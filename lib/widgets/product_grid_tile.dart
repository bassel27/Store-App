import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/screens/product_detail_screen.dart';

import '../providers/cart.dart';
import '../providers/productNotifier.dart';

class ProductGridTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context,
        listen:
            false); // the whole build method executes whenever this data changes if listen is true // listen: false to get the data which don't change (everything except is Favorite) so as not to rebuild
    final CartNotifier cart = Provider.of<CartNotifier>(context,
        listen:
            false); // you only add to the cart in this widget so there's no need to lsiten
    return LayoutBuilder(
      builder: (ctx, constraints) => GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.route, arguments: product);
        },
        child: Card(
          child: Column(children: [
            Stack(
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
                Consumer<Product>(
                    // this is the only part that will get rebuilt because this is what we need to change. Everything else doesn't change. Listen is always true in consumer another way to rebuild this part only is to place the following widgets in a separate file and use Provider.of(context) such that this file rebuilds itself without affecting the rest. // With consumer, you can split your widget such that only the part in the builder gets rebuilt
                    builder: (context, product, _) =>
                        _MyFloatingActionButton(product)
                    // child is a reference to the Consumer's child property which doesn't rebuild

                    ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.title,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "EGP ${product.price.toString()}",
                ),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class _MyFloatingActionButton extends StatelessWidget {
  final Product product;
  _MyFloatingActionButton(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, right: 7),
      width: 25,
      height: 25,
      child: FloatingActionButton(
        onPressed: product.toggleFavoriteStatus,
        child: Icon(
          size: 20,
          product.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: kAccentColor,
        ),
      ),
    );
  }
}

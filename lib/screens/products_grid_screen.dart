import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_notifier.dart';
import '../providers/products_notifier.dart';
import '../widgets/empty_screen_text.dart';
import '../widgets/product_grid_tile.dart';
import '../widgets/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';

/// This screen is used for home and favorites screens.
class ProductsGridScreen extends StatelessWidget {
  final bool _showFavoritesOnly;
  const ProductsGridScreen(this._showFavoritesOnly);
  // TODO: unfavorite makes item disappear from favoorites screen

  @override
  Widget build(BuildContext context) {
    final productsNotifier = Provider.of<ProductsNotifier>(context);
    final List<Product> products = _showFavoritesOnly
        ? productsNotifier.favoriteProducts
        : productsNotifier.products;
    // .of(context) sets up a direct communication channel in the widget tree
    // Provider makes the connection to one of the provider classes
    // the angle brackets specify which provider you want to listen to.
    // You want to listen to the provider which provides you with an instance
    //of your Products class
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          title: _showFavoritesOnly
              ? const Text("Favorites")
              : const Text("Pharmastore")),
      body: products.isNotEmpty
          ? GridView.builder(
              // padding: const EdgeInsets.only(top: 10),
              itemCount: products.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 2,
                height: 250,
              ),
              itemBuilder: (context, i) {
                return ChangeNotifierProvider<ProductNotifier>.value(
                  // use .value if you use provider on on an object that has already been created or something that is part of a list or a grid
                  value: ProductNotifier(products[i]),
                  builder: (context, child) {
                    return ProductGridTile(products[i]);
                  },
                );
              },
            )
          : const EmptyScreenText("No favorite products"),
    );
  }
}

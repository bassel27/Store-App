import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_notifier.dart';
import '../providers/products_notifier.dart';
import '../widgets/my_drawer.dart';
import '../widgets/product_grid_tile.dart';
import '../widgets/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';

/// This screen is used for home and favorites screens.
class ProductsGridScreen extends StatelessWidget {
  final bool showFavoritesOnly;
  const ProductsGridScreen(this.showFavoritesOnly);
  // TODO: unfavorite makes item disappear from favoorites screen

  @override
  Widget build(BuildContext context) {
    final productsNotifier = Provider.of<ProductsNotifier>(context);
    final List<Product> products = showFavoritesOnly
        ? productsNotifier.favoriteProducts
        : productsNotifier.products;
    // .of(context) sets up a direct communication channel in the widget tree
    // Provider makes the connection to one of the provider classes
    // the angle brackets specify which provider you want to listen to.
    // You want to listen to the provider which provides you with an instance
    //of your Products class
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
          title: showFavoritesOnly
              ? const Text("Favorites")
              : const Text("Pharmastore")),
      body: GridView.builder(
        // padding: const EdgeInsets.only(top: 10),
        itemCount: products.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          crossAxisCount: 2,
          height: 200,
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
      ),
    );
  }
}

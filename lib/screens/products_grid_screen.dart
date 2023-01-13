import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/productNotifier.dart';
import '../providers/products.dart';
import '../widgets/my_drawer.dart';
import '../widgets/product_grid_tile.dart';
import '../widgets/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';

class ProductsGridScreen extends StatelessWidget {
  final bool showFavoritesOnly;
  const ProductsGridScreen(this.showFavoritesOnly);
  // TODO: unfavorite makes item disappear from favoorites screen

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final List<Product> products = showFavoritesOnly
        ? productsData.favoriteProducts
        : productsData.products;
    // .of(context) sets up a direct communication channel in the widget tree
    // Provider makes the connection to one of the provider classes
    // the angle brackets specify which provider you want to listen to.
    // You want to listen to the provider which provides you with an instance
    //of your Products class
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
          title: showFavoritesOnly ? const Text("Favorites") : const Text("Pharmastore")),
      body: GridView.builder(
        // padding: const EdgeInsets.only(top: 10),
        itemCount: products.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          crossAxisCount: 2,
          height: 190,
          // TODO: 3/2: a bit taller than they're wide
        ),
        itemBuilder: (context, i) {
          return ChangeNotifierProvider.value(
            // use .value if you use provider on on an object that has already been created or something that is part of a list or a grid
            value: products[i],
            child: ProductGridTile(),
          );
        },
      ),
    );
  }
}

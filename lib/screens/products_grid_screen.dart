import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/productNotifier.dart';
import '../providers/products.dart';
import '../widgets/my_drawer.dart';
import '../widgets/product_grid_tile.dart';

class ProductsGridScreen extends StatelessWidget {
  final bool showFavoritesOnly;
  const ProductsGridScreen(this.showFavoritesOnly);
  // TODO: unfavorite makes item disappear from favoorites screen

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final List<ProductNotifier> products = showFavoritesOnly
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
          title: showFavoritesOnly ? Text("Favorites") : Text("Pharmastore")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: 3 / 2, // TODO: 3/2: a bit taller than they're wide
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';
import '../widgets/product_grid_tile.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Product> products = Provider.of<Products>(context).productsList;
    // .of(context) sets up a direct communication channel in the widget tree
    // Provider makes the connection to one of the provider classes
    // the angle brackets specify which provider you want to listen to.
    // You want to listen to the provider which provides you with an instance
    //of your Products class
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: 3 / 2, // TODO: 3/2: a bit taller than they're wide
        ),
        itemBuilder: (context, index) {
          return ProductGridTile(products[index]);
        });
  }
}

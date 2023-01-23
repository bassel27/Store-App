import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/products_notifier.dart';
import 'package:store_app/screens/edit_product_screen.dart';

import '../models/product.dart';

class ProductsManagerScreen extends StatelessWidget {
  const ProductsManagerScreen({super.key});
  static const route = "/product_manager_screen";

  @override
  Widget build(BuildContext context) {
    var productsProvider =
        Provider.of<ProductsNotifier>(context, listen: false);
    // in case you used edited product and wanna use it again (entered editscreen -> got out -> entered again)
    List<Product> products = Provider.of<ProductsNotifier>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Manager"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.route)
                    .then((_) => productsProvider.resetEditedProduct());
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(products[i].imageUrl),
                ),
                title: Text(products[i].name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, EditProductScreen.route,
                                arguments: products[i])
                            .then((_) => productsProvider.resetEditedProduct());
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).errorColor,
                        ))
                  ],
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}

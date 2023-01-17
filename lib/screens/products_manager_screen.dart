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
    List<Product> products = Provider.of<ProductsNotifier>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Manager"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.route);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          Product currentProduct = products[i];
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(currentProduct.imageUrl),
                ),
                title: Text(currentProduct.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
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

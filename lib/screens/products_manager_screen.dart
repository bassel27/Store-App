import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/products_notifier.dart';
import 'package:store_app/screens/edit_product_screen.dart';
import 'package:store_app/widgets/my_dismissble.dart';

import '../models/product.dart';

class ProductsManagerScreen extends StatelessWidget {
  const ProductsManagerScreen({super.key});
  static const route = "/product_manager_screen";

  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsNotifier>(context);

    List<Product> products = Provider.of<ProductsNotifier>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Manager"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.route).then(
                    (_) => productsProvider
                        .resetEditedProduct()); // in case you used edited product and wanna use it again (entered editscreen -> got out -> entered again)
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => productsProvider.getAndSetProducts(),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (_, i) {
            return Column(
              key: ValueKey(products[i].id),
              children: [
                MyDismissible(
                  valueKeyId: products[i].id,
                  onDismissed: (_) => onProductDelete(products[i], context),
                  child: _ProductListTile(products[i]),
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  final Product product;
  const _ProductListTile(this.product);
  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsNotifier>(context);

    List<Product> products = productsProvider.products;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.route,
                      arguments: product)
                  .then((_) => productsProvider.resetEditedProduct());
            },
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () => onProductDelete(product, context),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
          )
        ],
      ),
    );
  }
}

void onProductDelete(Product product, BuildContext context) async {
  var productsProvider = Provider.of<ProductsNotifier>(context, listen: false);
  var scaffoldMessenger = ScaffoldMessenger.of(context);
  int productOldIndex;
  try {
    productOldIndex = await productsProvider.deleteProduct(product.id);
  } catch (e) {
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(const SnackBar(
      content: Text("Deleting failed! Product is not available."),
    ));
    return;
  }

  scaffoldMessenger
      .hideCurrentSnackBar(); // to hide the previous snackbar if exists
  // TODO: latest: on undo, show loading screen
  scaffoldMessenger.showSnackBar(SnackBar(
    content: const Text("Product deleted"),
    padding: const EdgeInsets.symmetric(horizontal: 15),
    action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          productsProvider.addProductByIndex(product, productOldIndex);
        }),
  ));
}

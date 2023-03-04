import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/providers/product_image_notifier.dart';
import 'package:store_app/providers/products_notifier.dart';
import 'package:store_app/screens/edit_product_screen.dart';
import 'package:store_app/widgets/my_dismissble.dart';

import '../controllers/error_handler.dart';
import '../models/product/product.dart';
import '../widgets/empty_screen_text.dart';
import '../widgets/product_circle_avatar.dart';

class ProductsManagerScreen extends StatelessWidget {
  const ProductsManagerScreen({super.key});
  static const route = "/bottom_nav_bar/product_manager_screen";
  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsNotifier>(context);
    List<Product> products = productsProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Manager"),
        actions: [
          IconButton(
              onPressed: () => pushEditProductScreen(context),
              icon: const Icon(Icons.add)),
        ],
      ),
      body:
          //  RefreshIndicator(
          // onRefresh: () => productsProvider.getAndSetProducts(),
          // child:
          products.isEmpty
              ? const EmptyScreenText(
                  "No products.\n\nAdd some to get started!")
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    return Column(
                      key: ValueKey(products[i].id),
                      children: [
                        MyDismissible(
                          valueKeyId: products[i].id,
                          onDismissed: (_) =>
                              onProductDelete(products[i], context),
                          child: _ProductListTile(products[i]),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
      // ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  final Product product;
  const _ProductListTile(this.product);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProductCircleAvatar(product: product),
      title: Text(product.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => pushEditProductScreen(context, product),
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          IconButton(
            onPressed: () => onProductDelete(product, context),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
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
    content: const Text(
      "Product deleted",
      style: TextStyle(color: Colors.black),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 15),
    action: SnackBarAction(
        textColor: kTextDarkColor,
        label: 'UNDO',
        onPressed: () {
          try {
            productsProvider.addProductByIndex(product, productOldIndex);
          } catch (e) {
            ErrorHandler().handleError(e);
          }
        }),
  ));
}

void pushEditProductScreen(BuildContext context, [Product? product]) {
  Navigator.of(context)
      .push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (context) => ProductImageNotifier(),
                builder: (context, child) => EditProductScreen(product),
              )))
      .then((_) {
    Provider.of<ProductsNotifier>(context, listen: false).resetEditedProduct();
  }); // in case you used edited product and wanna use it again (entered editscreen -> got out -> entered again)
}

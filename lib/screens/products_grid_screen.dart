import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products_notifier.dart';
import '../widgets/empty_screen_text.dart';
import '../widgets/product_grid_tile.dart';
import '../widgets/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';

/// This screen is used for home and favorites screens.
class ProductsGridScreen extends StatefulWidget {
  final bool showFavoritesOnly;
  const ProductsGridScreen(this.showFavoritesOnly);

  @override
  State<ProductsGridScreen> createState() => _ProductsGridScreenState();
}

class _ProductsGridScreenState extends State<ProductsGridScreen> {
  late Future _fetchAndSetProductsFuture;
  @override
  void initState() {
    // don't use async here case you're supposed to be overriding it and not change its type
    super.initState();
    _fetchAndSetProductsFuture = fetchAndSetProducts();
  }

  Future<void> fetchAndSetProducts() {
    ProductsNotifier productsProvider =
        Provider.of<ProductsNotifier>(context, listen: false);
    if (productsProvider.products.isEmpty) {
      return productsProvider.fetchAndSetProducts();
    } else {
      return Future.delayed(Duration.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsNotifier = Provider.of<ProductsNotifier>(context);
    final List<Product> products = widget.showFavoritesOnly
        ? productsNotifier.favoriteProducts
        : productsNotifier.products;

    return FutureBuilder(
      future: _fetchAndSetProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
          } else if (snapshot.hasData) {
            return _MyScaffold(
                showFavoritesOnly: widget.showFavoritesOnly,
                products: products,
                connectionState: ConnectionState.done);
          }
          else {
            
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _MyScaffold(
              showFavoritesOnly: widget.showFavoritesOnly,
              products: products,
              connectionState: ConnectionState.waiting);
        } else {}
      },
    );
  }
}

class _MyScaffold extends StatelessWidget {
  _MyScaffold({
    Key? key,
    required this.showFavoritesOnly,
    required this.products,
    required this.connectionState,
  }) : super(key: key);

  final bool showFavoritesOnly;
  final List<Product> products;
  final ConnectionState connectionState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            title: showFavoritesOnly
                ? const Text("Favorites")
                : const Text("Pharmastore")),
        body: scaffoldBody[connectionState] as Widget);
  }

  late Map<ConnectionState, Widget> scaffoldBody = {
    ConnectionState.waiting: const Center(child: CircularProgressIndicator()),
    ConnectionState.done: (products.isNotEmpty
        ? GridView.builder(
            // padding: const EdgeInsets.only(top: 10),
            itemCount: products.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
              crossAxisCount: 2,
              height: 250,
            ),
            itemBuilder: (context, i) {
              return ProductGridTile(products[i]);
            },
          )
        : (showFavoritesOnly
            ? const EmptyScreenText("No favorite products")
            : const EmptyScreenText("No Products"))),
  };
}

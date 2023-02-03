import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/widgets/error_scaffold_body.dart';

import '../models/product.dart';
import '../providers/products_notifier.dart';
import '../widgets/empty_screen_text.dart';
import '../widgets/product_grid_tile.dart';
import '../widgets/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';

// TODO: stateless?
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
    _fetchAndSetProductsFuture = getAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: widget.showFavoritesOnly
              ? const Text("Favorites")
              : const Text("Pharmastore")),
      body: Center(
        child: FutureBuilder(
          future: _fetchAndSetProductsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ErrorScaffoldBody(snapshot.error as Exception);
              } else {
                return _SuccessfulScaffoldBody(
                    showFavoritesOnly: widget.showFavoritesOnly);
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }

  Future<void> getAndSetProducts() {
    ProductsNotifier productsProvider =
        Provider.of<ProductsNotifier>(context, listen: false);
    if (!productsProvider.areProductsFetched) {
      return productsProvider.getAndSetProducts();
    } else {
      return Future.delayed(Duration.zero);
    }
  }
}

class _SuccessfulScaffoldBody extends StatelessWidget {
  const _SuccessfulScaffoldBody({
    Key? key,
    required this.showFavoritesOnly,
  }) : super(key: key);

  final bool showFavoritesOnly;

  @override
  Widget build(BuildContext context) {
    final productsNotifier = Provider.of<ProductsNotifier>(context);
    final List<Product> products = showFavoritesOnly
        ? productsNotifier.favoriteProducts
        : productsNotifier.products;
    return Center(
        child: products.isNotEmpty
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
                : const EmptyScreenText("No Products")));
  }
}

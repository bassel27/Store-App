import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  // starting value is true
  late bool _isLoading = true;
  @override
  void initState() {
    // don't use async here case you're supposed to be overriding it and not change its type
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsNotifier>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsNotifier = Provider.of<ProductsNotifier>(context);
    final List<Product> products = widget.showFavoritesOnly
        ? productsNotifier.favoriteProducts
        : productsNotifier.products;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          title: widget.showFavoritesOnly
              ? const Text("Favorites")
              : const Text("Pharmastore")),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : products.isNotEmpty
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
              : (widget.showFavoritesOnly
                  ? const EmptyScreenText("No favorite products")
                  : const EmptyScreenText("No Products")),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product/product.dart';
import '../providers/products_notifier.dart';
import '../widgets/empty_screen_text.dart';
import '../widgets/product_grid_tile.dart';
import '../widgets/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';

// TODO: stateless?
/// This screen is used for home and favorites screens.
class ProductsGridScreen extends StatelessWidget {
  final bool showFavoritesOnly;
  const ProductsGridScreen(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          pinned: true,
          centerTitle: true,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.location_on_sharp),
            Text(" Delivering to ......."),
            Icon(Icons.keyboard_arrow_down_sharp),
          ]),
          bottom: AppBar(title: const _SearchBar(), actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.sort))
          ]),
        ),
        SliverToBoxAdapter(
          child: _ScaffoldBody(showFavoritesOnly: showFavoritesOnly),
        )
      ],
    ));
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20)),
      width: double.infinity,
      height: 40,
      child: const Center(
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for something',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}

class _ScaffoldBody extends StatelessWidget {
  const _ScaffoldBody({
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
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10),
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

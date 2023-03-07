import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/settings_screen.dart';

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
          leading: IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AccountScreen.route);
            },
          ),
          floating: true,
          snap: true,
          pinned: true,
          centerTitle: true,
          title: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                // border: Border.all(
                //   color: Colors.red,
                // ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: FittedBox(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                    ),
                    Text(
                      " Delivering to .......",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.white,
                    ),
                  ]),
            ),
          ),
          bottom:
              AppBar(elevation: 0, title: const _SearchBar(), actions: const [
            // IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list))
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
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0.5),
              blurRadius: 0.5,
              spreadRadius: 0.5,
              color: Colors.black26,
            ),
          ],
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.black,
          // ),
          borderRadius: BorderRadius.circular(5)),
      width: double.infinity,
      height: 40,
      child: const Center(
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            prefixIcon: Icon(Icons.search_sharp),
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
                height: 390,
              ),
              itemBuilder: (context, i) {
                return ProductGridTile(products[i]);
              },
            )
          : Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                ),
                (showFavoritesOnly
                    ? const EmptyScreenText("No favorite products")
                    : const EmptyScreenText("No Products")),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/settings_screen.dart';
import 'package:store_app/widgets/my_search_bar.dart';

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
          bottom: AppBar(
            elevation: 0,
            title: const _SearchBar(),
          ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final suggestionsList =
        Provider.of<ProductsNotifier>(context, listen: false)
            .items
            .map((e) => e.title)
            .toList()
            .toSet()
            .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        height: kToolbarHeight - 10,
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(250)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.13),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: MySearchBar(
              elevation: 10,
              backgroundColor: colorScheme.primary,
              searchBackgroundColor: colorScheme.background,
              searchCursorColor: colorScheme.tertiary,
              searchBackIconTheme: IconThemeData(color: colorScheme.tertiary),
              suggestionBackgroundColor: colorScheme.background,
              title: const Text(
                'Search',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
              ),
              onSearch: (value) => print(value),
              suggestions: suggestionsList,
            ),
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
                height: 340,
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

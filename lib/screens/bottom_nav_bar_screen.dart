import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/products_notifier.dart';

import '../models/product/product.dart';
import '../providers/cart_notifier.dart';
import '../screens/cart_screen.dart';
import '../screens/products_grid_screen.dart';

//TODO: replace with persistent nav bar
class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});
  static const route = '/bottom_nav_bar';
  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 1;
  late final CartNotifier cartNotifier = Provider.of<CartNotifier>(context);

  @override
  Widget build(BuildContext context) {
    ProductsNotifier productsProvider =
        Provider.of<ProductsNotifier>(context, listen: false);
    List<Product> favoriteProducts = productsProvider.favoriteProducts;
    List<Product> products = productsProvider.products;
    var screenToBottomNavBarItem = {
      ProductsGridScreen(favoriteProducts): const BottomNavigationBarItem(
        icon: Icon(Icons.favorite_outline),
        label: 'Favorites',
      ),
      ProductsGridScreen(products): const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
      ),
      // const CategoriesScreen(): const BottomNavigationBarItem(
      //   icon: Icon(Icons.category_outlined),
      //   label: 'Categories',
      // ),
      CartScreen(): BottomNavigationBarItem(
        icon: Badge(
          badgeStyle: BadgeStyle(
            badgeColor: Theme.of(context).colorScheme.secondary,
          ),
          badgeContent: Text(
            cartNotifier.cartItemsCount.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          child: const Icon(Icons.shopping_cart_outlined),
        ),
        label: 'Cart',
      ),
    };

    return Scaffold(
      body: screenToBottomNavBarItem.keys.toList()[_selectedIndex],
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: screenToBottomNavBarItem.values.toList(),
          currentIndex: _selectedIndex,
          onTap: _onTap,
        ),
      ),
    );
  }

  void _onTap(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }
}

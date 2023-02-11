import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/my_theme.dart';
import '../providers/cart_notifier.dart';
import '../screens/cart_screen.dart';
import '../screens/products_grid_screen.dart';
import '../screens/settings_screen.dart';
import 'categories_screen.dart';

//TODO: replace with persistent nav bar
class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 2;
  late final CartNotifier cartNotifier = Provider.of<CartNotifier>(context);

  @override
  Widget build(BuildContext context) {
    var screenToBottomNavBarItem = {
      AccountScreen(): const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: 'Account',
      ),
      const ProductsGridScreen(true): const BottomNavigationBarItem(
        icon: Icon(Icons.favorite_outline),
        label: 'Favorites',
      ),
      const ProductsGridScreen(false): const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
      ),
      const CategoriesScreen(): const BottomNavigationBarItem(
        icon: Icon(Icons.category_outlined),
        label: 'Categories',
      ),
      const CartScreen(): BottomNavigationBarItem(
        icon: Badge(
          badgeColor: Theme.of(context).colorScheme.background,
          badgeContent: Text(cartNotifier.cartItemsCount.toString()),
          child: const Icon(Icons.shopping_cart_outlined),
        ),
        label: 'Cart',
      ),
    };

    return Scaffold(
      body: screenToBottomNavBarItem.keys.toList()[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            color: Colors.green,
            border: Border(top: BorderSide(color: Colors.black))),
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

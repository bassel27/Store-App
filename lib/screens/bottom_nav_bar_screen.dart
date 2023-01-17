import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/screens/cart_screen.dart';
import 'package:store_app/screens/orders_screen.dart';
import 'package:store_app/screens/products_grid_screen.dart';
import 'package:store_app/screens/settings_screen.dart';

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
      SettingsScreen(): const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
      const ProductsGridScreen(true): const BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favorites',
      ),
      const ProductsGridScreen(false): const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const OrdersScreen(): const BottomNavigationBarItem(
        icon: Icon(Icons.list_alt_sharp),
        label: 'Orders',
      ),
      const CartScreen(): BottomNavigationBarItem(
        icon: Badge(
          badgeColor: kSecondaryColor,
          badgeContent: Text(cartNotifier.cartItemsCount.toString()),
          child: const Icon(Icons.shopping_cart),
        ),
        label: 'Cart',
      ),
    };

    return Scaffold(
      body: screenToBottomNavBarItem.keys.toList()[_selectedIndex],
      bottomNavigationBar: Consumer<CartNotifier>(
        builder: (_, cart, child) => BottomNavigationBar(
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

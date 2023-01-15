import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/cart_screen.dart';
import 'package:store_app/screens/products_grid_screen.dart';
import 'package:store_app/screens/settings_screen.dart';
import 'package:badges/badges.dart';
import 'package:store_app/providers/cart_notifier.dart';
import '../widgets/my_drawer.dart';
import 'account_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 1;

  final List<Widget> _screens = <Widget>[
    const ProductsGridScreen(true),
    const ProductsGridScreen(false),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Consumer<CartNotifier>(
        builder: (_, cart, child) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                badgeColor: Theme.of(context).colorScheme.secondary,
                badgeContent: Text(cart.cartItemsCount.toString()),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'My Account',
            ),
          ],
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

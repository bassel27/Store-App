import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/cart_screen.dart';
import 'package:store_app/screens/products_grid_screen.dart';
import 'package:store_app/screens/settings_screen.dart';
import 'package:badges/badges.dart';
import '../providers/cart.dart';
import '../widgets/my_drawer.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Consumer<CartNotifier>(
        builder: (_, cart, child) => BottomNavigationBar(
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
                badgeContent: Text(cart.cartItemsCount.toString()),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
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

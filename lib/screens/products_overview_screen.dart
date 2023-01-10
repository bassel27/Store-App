import 'package:flutter/material.dart';
import 'package:store_app/screens/products_grid.dart';
import 'package:store_app/screens/settings_screen.dart';
import 'package:store_app/widgets/product_grid_tile.dart';
import '../models/product.dart';

class ProductsOverViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(
        children: [
          SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          )
        ],
      )),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
        title: const Text("Pharmastore"),
      ),
      body: ProductsGrid(),
    );
  }
}

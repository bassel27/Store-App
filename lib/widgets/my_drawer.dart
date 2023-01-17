import 'package:flutter/material.dart';
import 'package:store_app/screens/products_manager_screen.dart';

import '../screens/settings_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        const SizedBox(height: 30),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("Manage Products"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ProductsManagerScreen.route);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Settings"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(SettingsScreen.route);
          },
        ),
      ],
    ));
  }
}

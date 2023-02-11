import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/theme_notifier.dart';
import 'package:store_app/screens/orders_screen.dart';
import 'package:store_app/screens/products_manager_screen.dart';

class AccountScreen extends StatefulWidget {
  static const route = "/settings";
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late var theme = Provider.of<ThemeNotifier>(context, listen: false);
  late bool _switchValue = theme.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(children: [
        ListTile(
          leading: const Icon(Icons.dark_mode_outlined),
          title: const Text("Dark Mode"),
          trailing: Switch(
            value: _switchValue,
            onChanged: (value) {
              theme.toggleThemeMode(value);
              setState(() {
                _switchValue = !_switchValue;
              });
            },
          ),
        ),
        const Divider(),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductsManagerScreen.route);
          },
          child: const ListTile(
            leading: Icon(Icons.edit),
            title: Text("Products Manager"),
          ),
        ),
        const Divider(),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, OrdersScreen.route);
          },
          child: const ListTile(
            leading: Icon(Icons.list_alt_rounded),
            title: Text("Orders"),
          ),
        ),
        const Divider(),
      ]),
    );
  }
}

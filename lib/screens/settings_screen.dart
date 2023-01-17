import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/theme_notifier.dart';
import 'package:store_app/screens/products_manager_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const route = "/settings";
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late var theme = Provider.of<ThemeNotifier>(context);
  late bool _switchValue = theme.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
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
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProductsManagerScreen.route);
            },
            child: const ListTile(
              leading: Icon(Icons.edit),
              title: Text("Products Manager"),
            ),
          ),
        ],
      ),
    );
  }
}

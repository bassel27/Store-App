import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/theme_notifier.dart';
import 'package:store_app/widgets/my_drawer.dart';

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
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Row(
          children: [
            const Text("Dark Mode"),
            Switch(
              value: _switchValue,
              onChanged: (value) {
                theme.toggleThemeMode(value);
                setState(() {
                  _switchValue = !_switchValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/theme.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late var theme = Provider.of<ThemeNotifier>(context);
  late bool _switchValue = theme.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Row(
          children: [
            Text("Dark Mode"),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth_notifier.dart';
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
  double circleAvatarRadius = 60;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
      ),
      body: ListView(children: [
        const SizedBox(
          height: 20,
        ),
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          radius: circleAvatarRadius,
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
            size: circleAvatarRadius + 40,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Center(
            child: Text(
          "Bassel Attia",
          style: TextStyle(fontSize: 22),
        )),
        const SizedBox(
          height: 20,
        ),
        _ClickableListTile(
          icon: Icons.list_alt_rounded,
          onTap: () {
            Navigator.pushNamed(context, OrdersScreen.route);
          },
          title: "Orders",
        ),
        // const Divider(),
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
        // const Divider(),
        _ClickableListTile(
          icon: Icons.edit,
          onTap: () {
            Navigator.pushNamed(context, ProductsManagerScreen.route);
          },
          title: "Products Manager",
        ),
        _ClickableListTile(
          icon: Icons.logout,
          onTap: () async{
            // Navigator.pop(context);
            await Provider.of<AuthNotifier>(context, listen: false).logout();
            Navigator.of(context).pushReplacementNamed(
                '/'); // to go to the home screen (authentication)
          },
          title: "Logout",
        ),
        // const Divider(),
      ]),
    );
  }
}

class _ClickableListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  const _ClickableListTile({
    required this.onTap,
    required this.title,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }
}

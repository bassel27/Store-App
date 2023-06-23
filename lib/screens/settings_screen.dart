import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth_notifier.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/providers/user_notifier.dart';
import 'package:store_app/screens/chat_screen.dart';
import 'package:store_app/screens/orders_screen.dart';
import 'package:store_app/screens/products_manager_screen.dart';

import '../providers/cart_notifier.dart';
import '../providers/products_notifier.dart';
import '../providers/theme_notifier.dart';

class AccountScreen extends StatefulWidget {
  static const route = "/bottom_nav_bar/my_account";
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late var theme = Provider.of<ThemeNotifier>(context, listen: false);
  late bool switchValue = theme.isDarkMode;
  double circleAvatarRadius = 60;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
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
        Center(
            child: Text(
          "${userProvider.currentUser!.firstName} ${userProvider.currentUser!.lastName}",
          style: const TextStyle(fontSize: 22),
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
        userProvider.currentUser!.isAdmin
            ? _ClickableListTile(
                icon: Icons.edit,
                onTap: () {
                  Navigator.pushNamed(context, ProductsManagerScreen.route);
                },
                title: "Products Manager",
              )
            : Container(),
        _ClickableListTile(
            onTap: () {
              Navigator.pushNamed(context, ChatScreen.route);
            },
            title: 'Chat Support',
            icon: Icons.chat),
        ListTile(
          leading: const Icon(Icons.dark_mode_outlined),
          title: const Text("Dark Mode"),
          trailing: Switch(
            value: switchValue,
            onChanged: (value) {
              theme.toggleThemeMode(value);
              setState(() {
                switchValue = !switchValue;
              });
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text("Delete Account"),
          onTap: showConfirmationDialog,
        ),
        _ClickableListTile(
          icon: Icons.logout,
          onTap: () async {
            // Navigator.pop(context);
            await Provider.of<AuthNotifier>(context, listen: false).signout();
            Navigator.of(context).pushReplacementNamed(
                '/'); // to go to the home screen (authentication)
            Provider.of<OrdersNotifier>(context, listen: false).reset();
            Provider.of<ProductsNotifier>(context, listen: false).reset();
            Provider.of<CartNotifier>(context, listen: false).reset();
          },
          title: "Logout",
        ),

        // const Divider(),
      ]),
    );
  }

  showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
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

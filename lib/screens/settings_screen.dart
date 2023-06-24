import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/controllers/excpetion_handler.dart';
import 'package:store_app/providers/auth_notifier.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/providers/user_notifier.dart';
import 'package:store_app/screens/about_screen.dart';
import 'package:store_app/screens/chat_screen.dart';
import 'package:store_app/screens/orders_screen.dart';
import 'package:store_app/screens/products_manager_screen.dart';
import 'package:store_app/widgets/notification_widget.dart';

import '../providers/cart_notifier.dart';
import '../providers/products_notifier.dart';
import '../providers/theme_notifier.dart';
import '../services/dialog_helper.dart';

class AccountScreen extends StatefulWidget {
  static const route = "/bottom_nav_bar/my_account";
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with ExceptionHandler {
  final double circleAvatarRadius = 60;
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
        const ListTiles(),
      ]),
    );
  }
}

class ListTiles extends StatefulWidget {
  const ListTiles({super.key});

  @override
  State<ListTiles> createState() => _ListTilesState();
}

class _ListTilesState extends State<ListTiles> with ExceptionHandler {
  late var theme = Provider.of<ThemeNotifier>(context, listen: false);
  late bool switchValue = theme.isDarkMode;

  bool isMarketingOn = false;
  bool isPersonalNotificationsOn = true;
//TODO:  revise
  @override
  void initState() {
    super.initState();
    NotificationWidget.init();
    getMarketingOnStatus();
  }

  Future<void> getMarketingOnStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isMarketingOn = prefs.getBool('isMarketingOn') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    return Column(
      children: [
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
          leading: const Icon(Icons.notifications_active),
          title: const Text("Send Notification"),
          onTap: () {
            NotificationWidget.showNotification(
                title: "Notification", body: "Test");
          },
        ),
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
          leading: const Icon(Icons.notifications),
          title: const Text("Marketing Notifications"),
          trailing: Switch(
            value: isMarketingOn,
            onChanged: (value) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (!value) {
                await FirebaseMessaging.instance
                    .unsubscribeFromTopic('newProduct');
              } else {
                await FirebaseMessaging.instance.subscribeToTopic('newProduct');
              }
              await prefs.setBool('isMarketingOn', value);
              isMarketingOn = value;
              setState(() {});
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text("Personal Notifications"),
          trailing: Switch(
            value: isPersonalNotificationsOn,
            onChanged: (value) {
              setState(() {
                isPersonalNotificationsOn = value;
              });
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text("Delete Account"),
          onTap: showConfirmationDialog,
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text("About"),
          onTap: () {
            Navigator.pushNamed(context, AboutScreen.route);
          },
        ),
        _ClickableListTile(
          icon: Icons.logout,
          onTap: () async {
            try {
              await logoutAndReset();
            } catch (e) {
              handleException(e);
            }
          },
          title: "Logout",
        ),
      ],
    );
  }

  Future<void> logoutAndReset() async {
    await Provider.of<AuthNotifier>(context, listen: false).signout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(
          '/'); // to go to the home screen (authentication)
      Provider.of<OrdersNotifier>(context, listen: false).reset();
      Provider.of<ProductsNotifier>(context, listen: false).reset();
      Provider.of<CartNotifier>(context, listen: false).reset();
    }
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        SystemSound.play(SystemSoundType.alert);
        HapticFeedback.lightImpact();
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Reduce the dialog's height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Are you sure you want to delete your account?"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                SystemSound.play(SystemSoundType.click);
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                SystemSound.play(SystemSoundType.click);
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
                DialogHelper.showLoading();
                final userNotifier =
                    Provider.of<UserNotifier>(context, listen: false);
                await userNotifier.deleteCurrentUser();
                await logoutAndReset();
                DialogHelper.hideCurrentDialog();
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

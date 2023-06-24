import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/data/models/my_theme.dart';
import 'package:store_app/presentation/notifiers/auth_notifier.dart';
import 'package:store_app/presentation/notifiers/cart_notifier.dart';
import 'package:store_app/presentation/notifiers/orders_notifier.dart';
import 'package:store_app/presentation/notifiers/products_notifier.dart';
import 'package:store_app/presentation/notifiers/selected_size.dart';
import 'package:store_app/presentation/notifiers/theme_notifier.dart';
import 'package:store_app/presentation/notifiers/user_notifier.dart';
import 'package:store_app/presentation/pages/about_screen.dart';
import 'package:store_app/presentation/pages/address_screen.dart';
import 'package:store_app/presentation/pages/auth_screen.dart';
import 'package:store_app/presentation/pages/bottom_nav_bar_screen.dart';
import 'package:store_app/presentation/pages/chat_screen.dart';
import 'package:store_app/presentation/pages/edit_product_screen.dart';
import 'package:store_app/presentation/pages/order_screen.dart';
import 'package:store_app/presentation/pages/orders_screen.dart';
import 'package:store_app/presentation/pages/settings_screen.dart';
import 'package:store_app/presentation/pages/verify_email_screen.dart';
import 'package:store_app/presentation/widgets/notification_widget.dart';

import 'presentation/pages/product_details_screen.dart';
import 'presentation/pages/products_manager_screen.dart';



Future<void> _onBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    final data = message.data;
    final title = data['title'];
    final body = data['message'];
    NotificationWidget.showNotification(title: title, body: body);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isMarketingOn = prefs.getBool('isMarketingOn') ?? true;
  if (isMarketingOn) {
    final fcm = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessageHandler);
    await fcm.subscribeToTopic('newProduct');
  }
  ThemeNotifier themeNotifier = ThemeNotifier();
  await themeNotifier.loadThemeMode();
  runApp(MyApp(themeNotifier));
}

class MyApp extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  MyApp(this.themeNotifier);
  late var providers = [
    ChangeNotifierProvider(create: (_) => AuthNotifier()),
    ChangeNotifierProvider(create: (context) => ProductsNotifier()),
    ChangeNotifierProvider(
      create: (context) => CartNotifier(),
    ),
    ChangeNotifierProxyProvider<AuthNotifier, OrdersNotifier>(
      update: (context, auth, previousOrdersProvider) => OrdersNotifier(),
      create: (context) => OrdersNotifier(),
    ),
    ChangeNotifierProvider.value(
      value: themeNotifier,
    ),
    ChangeNotifierProvider(create: (_) => SizeNotifier()),
    ChangeNotifierProvider(create: (_) => UserNotifier()),
  ];
  @override
  Widget build(BuildContext context) {
    removeShadowAboveAppBar();
    return MultiProvider(
      providers: providers,
      // TODO: use materialapp
      builder: (context, child) => GetMaterialApp(
        themeMode: Provider.of<ThemeNotifier>(context).currentThemeMode,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        routes: {
          BottomNavBarScreen.route: (p0) => const BottomNavBarScreen(),
          ProductDetailsScreen.route: (ctx) => ProductDetailsScreen(),
          OrdersScreen.route: (ctx) => OrdersScreen(),
          ProductsManagerScreen.route: (ctx) => const ProductsManagerScreen(),
          AccountScreen.route: (ctx) => AccountScreen(),
          EditProductScreen.route: (ctx) => const EditProductScreen(null),
          ChatScreen.route: (ctx) => const ChatScreen(),
          VerifyEmailPage.route: (ctx) => const VerifyEmailPage(),
          AuthScreen.route: (ctx) => AuthScreen(),
          AddressScreen.route: (ctx) => AddressScreen(),
          OrderScreen.route: (ctx) => const OrderScreen(),
          AboutScreen.route: (ctx) => AboutScreen(),
        },
        title: 'Flutter Demo',
        home: const LandingPage(),
      ),
    );
  }
}

void removeShadowAboveAppBar() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const VerifyEmailPage();
        }
        return AuthScreen();
      },  
    );
  }
}

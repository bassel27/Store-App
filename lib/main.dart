import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth_notifier.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/screens/auth_screen.dart';
import 'package:store_app/screens/bottom_nav_bar_screen.dart';
import 'package:store_app/screens/chat_screen.dart';
import 'package:store_app/screens/edit_product_screen.dart';
import 'package:store_app/screens/orders_screen.dart';
import 'package:store_app/screens/product_details_screen.dart';
import 'package:store_app/screens/products_manager_screen.dart';
import 'package:store_app/screens/settings_screen.dart';
import 'package:store_app/screens/verify_email_screen.dart';

import 'models/my_theme.dart';
import 'providers/products_notifier.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

//TODO: use something else except double for monetary values
Future<void> main() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var providers = [
    ChangeNotifierProvider(
        // here you're not using the .value because Products() object is created inside the changenotifierprovider
        create: (_) => AuthNotifier()), // the object you wanna keep track of
    ChangeNotifierProxyProvider<AuthNotifier, ProductsNotifier>(
        // this provider will be rebuilt when Auth changes
        update: (context, auth, previousProduct) => ProductsNotifier(
            previousProduct == null ? [] : previousProduct.items),
        create: (context) => ProductsNotifier([])),
    ChangeNotifierProxyProvider<AuthNotifier, CartNotifier>(
      update: (context, auth, previousCart) =>
          CartNotifier(previousCart == null ? [] : previousCart.cartItems),
      create: (context) => CartNotifier([]),
    ),
    ChangeNotifierProxyProvider<AuthNotifier, OrdersNotifier>(
      update: (context, auth, previousOrdersProvider) => OrdersNotifier(
          previousOrdersProvider == null ? [] : previousOrdersProvider.orders),
      create: (context) => OrdersNotifier([]),
    ),

    // ChangeNotifierProvider(
    //   create: (_) => ThemeNotifier(),
    // ),
  ];
  @override
  Widget build(BuildContext context) {
    removeShadowAboveAppBar();
    return MultiProvider(
      providers: providers,
      // TODO: use materialapp
      builder: (context, child) => Consumer<AuthNotifier>(
        builder: (context, auth, _) => GetMaterialApp(
          // themeMode: Provider.of<ThemeNotifier>(context).currentThemeMode,
          theme: MyTheme.lightTheme,
          // darkTheme: MyTheme.darkTheme,
          routes: {
            BottomNavBarScreen.route: (p0) => const BottomNavBarScreen(),
            ProductDetailsScreen.route: (ctx) => ProductDetailsScreen(),
            OrdersScreen.route: (ctx) => const OrdersScreen(),
            ProductsManagerScreen.route: (ctx) => const ProductsManagerScreen(),
            AccountScreen.route: (ctx) => AccountScreen(),
            EditProductScreen.route: (ctx) => const EditProductScreen(null),
            ChatScreen.route: (ctx) => const ChatScreen(),
            VerifyEmailPage.route: (ctx) => const VerifyEmailPage(),
          },
          title: 'Flutter Demo',
          home: const LandingPage(),
        ),
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

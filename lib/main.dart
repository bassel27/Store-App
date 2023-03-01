import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth_notifier.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/providers/product_image_notifier.dart';
import 'package:store_app/providers/theme_notifier.dart';
import 'package:store_app/screens/auth_screen.dart';
import 'package:store_app/screens/chat_screen.dart';
import 'package:store_app/screens/edit_product_screen.dart';
import 'package:store_app/screens/orders_screen.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import 'package:store_app/screens/products_manager_screen.dart';
import 'package:store_app/screens/settings_screen.dart';
import 'package:store_app/screens/splash_screen.dart';

import 'models/my_theme.dart';
import 'providers/products_notifier.dart';

//TODO: use something else except double for monetary values
void main() {
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
            auth, previousProduct == null ? [] : previousProduct.items),
        create: (context) => ProductsNotifier(
            Provider.of<AuthNotifier>(context, listen: false), [])),
    ChangeNotifierProxyProvider<AuthNotifier, CartNotifier>(
      update: (context, auth, previousCart) => CartNotifier(
          auth, previousCart == null ? [] : previousCart.cartItems),
      create: (context) =>
          CartNotifier(Provider.of<AuthNotifier>(context, listen: false), []),
    ),
    ChangeNotifierProxyProvider<AuthNotifier, OrdersNotifier>(
      update: (context, auth, previousOrdersProvider) => OrdersNotifier(auth,
          previousOrdersProvider == null ? [] : previousOrdersProvider.orders),
      create: (context) =>
          OrdersNotifier(Provider.of<AuthNotifier>(context, listen: false), []),
    ),
    ChangeNotifierProvider(
      create: (_) => ProductImageNotifier(),
    ),
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    removeShadowAboveAppBar();
    return MultiProvider(
      providers: providers,
      // TODO: use materialapp
      builder: (context, child) => Consumer<AuthNotifier>(
          builder: (context, auth, _) => GetMaterialApp(
              themeMode: Provider.of<ThemeNotifier>(context).currentThemeMode,
              theme: MyTheme.lightTheme,
              darkTheme: MyTheme.darkTheme,
              routes: {
                ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
                OrdersScreen.route: (ctx) => const OrdersScreen(),
                ProductsManagerScreen.route: (ctx) =>
                    const ProductsManagerScreen(),
                AccountScreen.route: (ctx) => AccountScreen(),
                EditProductScreen.route: (ctx) => const EditProductScreen(null),
                ChatScreen.route: (ctx) => const ChatScreen(),
              },
              title: 'Flutter Demo',
              home: auth.isAuth
                  ? const SplashScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, snapshot) => snapshot
                                  .connectionState ==
                              ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : AuthScreen(), // on future finished, if notifylisteners called, then splashscreen is displayed. If not, authscreen will be displayed
                    ))),
    );
  }
}

void removeShadowAboveAppBar() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/providers/theme_notifier.dart';
import 'package:store_app/screens/auth_screen.dart';
import 'package:store_app/screens/edit_product_screen.dart';
import 'package:store_app/screens/orders_screen.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import 'package:store_app/screens/products_manager_screen.dart';
import 'package:store_app/screens/settings_screen.dart';

import 'models/my_theme.dart';
import 'providers/products_notifier.dart';

//TODO: use something else except double for monetary values
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    removeShadowAboveAppBar();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            // here you're not using the .value because Products() object is created inside the changenotifierprovider
            create: (_) =>
                ProductsNotifier(), // the object you wanna keep track of
          ),
          ChangeNotifierProvider(
            create: (_) => CartNotifier(),
          ),
          ChangeNotifierProvider(
            create: (_) => ThemeNotifier(),
          ),
          ChangeNotifierProvider(
            create: (_) => OrdersNotifier(),
          ),
          ChangeNotifierProvider(create: (_) => Auth()),
        ],
        // TODO: use materialapp
        builder: (context, child) => GetMaterialApp(
            themeMode: Provider.of<ThemeNotifier>(context).currentThemeMode,
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            routes: {
              ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
              OrdersScreen.route: (ctx) => const OrdersScreen(),
              ProductsManagerScreen.route: (ctx) =>
                  const ProductsManagerScreen(),
              AccountScreen.route: (ctx) => AccountScreen(),
              EditProductScreen.route: (ctx) => EditProductScreen(),
            },
            title: 'Flutter Demo',
            home: child),
        child: AuthScreen());
  }
}

void removeShadowAboveAppBar() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

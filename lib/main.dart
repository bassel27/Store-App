import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/providers/theme_notifier.dart';
import 'package:store_app/screens/bottom_nav_bar_screen.dart';
import 'package:store_app/screens/orders_screen.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import 'package:store_app/screens/products_manager_screen.dart';
import 'package:store_app/screens/settings_screen.dart';

import 'models/my_theme.dart';
import 'providers/products_notifier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          create: (_) => Orders(),
        )
      ],
      builder: (context, child) => MaterialApp(
          themeMode: Provider.of<ThemeNotifier>(context).themeMode,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          routes: {
            ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
            OrdersScreen.route: (ctx) => const OrdersScreen(),
            ProductsManagerScreen.route: (ctx) => const ProductsManagerScreen(),
            SettingsScreen.route: (ctx) =>  SettingsScreen(),
          },
          title: 'Flutter Demo',
          home: child),
      child: const BottomNavBarScreen(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           // here you're not using the .value because Products() object is created inside the changenotifierprovider
//           create: (_) => Products(), // the object you wanna keep track of
//         ),
//         ChangeNotifierProvider(
//           create: (_) => CartNotifier(),
//         ),
//         ChangeNotifierProvider(
//           create: (_) => ThemeNotifier(),
//         ),
//       ],
//       builder: (context, child) => MaterialApp(
//         themeMode: Provider.of<ThemeNotifier>(context).themeMode,
//         theme: MyThemes.lightTheme,
//         darkTheme: MyThemes.darkTheme,
//         routes: {
//           ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
//         },
//         title: 'Flutter Demo',
//         home: BottomNavBarScreen(),
//       ),
//     );
//   }
// }
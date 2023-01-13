import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart.dart';
import 'package:store_app/providers/theme_provider.dart';
import 'package:store_app/screens/bottom_nav_bar_screen.dart';
import 'package:store_app/screens/product_detail_screen.dart';

import '../providers/products.dart';
import 'models/my_theme.dart';

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
          create: (_) => Products(), // the object you wanna keep track of
        ),
        ChangeNotifierProvider(
          create: (_) => CartNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, theme, child) => MaterialApp(
            themeMode: theme.themeMode,
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            routes: {
              ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
            },
            title: 'Flutter Demo',
            home: child),
        child: BottomNavBarScreen(),
      ),
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
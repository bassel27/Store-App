import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import 'package:store_app/screens/products_overview_screen.dart';
import 'package:store_app/theme/theme_constants.dart';
import 'package:store_app/theme/theme_manager.dart';
import '../providers/products.dart';

void main() {
  runApp(MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // here you're not using the .value because Products() object is created inside the changenotifierprovider
      create: (ctx) => Products(),  // the object you wanna keep track of 
      child: MaterialApp(
        routes: {
          ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
        },
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeManager.themeMode,
        title: 'Flutter Demo',
        home: ProductsOverViewScreen(),
      ),
    );
  }
}

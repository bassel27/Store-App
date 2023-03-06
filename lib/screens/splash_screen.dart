import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';

import '../providers/products_notifier.dart';
import '../widgets/error_scaffold_body.dart';
import 'bottom_nav_bar_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.wait([
            context.read<CartNotifier>().getAndSetCart(),
            Provider.of<ProductsNotifier>(context, listen: false)
                .getAndSetProducts()
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ErrorScaffoldBody(snapshot.error as Exception);
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      BottomNavBarScreen.route, (route) => false);
                });
              }
            }
            return Lottie.asset('assets/animations/shopping2.json',
                width: MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}

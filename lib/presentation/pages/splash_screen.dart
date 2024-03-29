import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../notifiers/cart_notifier.dart';
import '../notifiers/products_notifier.dart';
import '../notifiers/user_notifier.dart';
import '../widgets/exception_scaffold_body.dart';
import 'bottom_nav_bar_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.wait([
            Provider.of<CartNotifier>(context, listen: false).getAndSetCart(),
            Provider.of<ProductsNotifier>(context, listen: false)
                .getAndSetProducts(),
            Provider.of<UserNotifier>(context, listen: false)
                .getAndSetCurrentUser(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ExceptionScaffoldBody(snapshot.error as Exception);
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

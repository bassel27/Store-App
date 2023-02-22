import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';

import '../providers/products_notifier.dart';
import '../widgets/my_future_builder.dart';
import 'bottom_nav_bar_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFutureBuilder(
      future: Future.wait([
        context.read<CartNotifier>().getAndSetCart(),
        context.read<ProductsNotifier>().getAndSetProducts()
      ]),
      onSuccessWidget: const BottomNavBarScreen(),
      onLoadingWidget: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Lottie.asset('assets/animations/shopping2.json',
              width: MediaQuery.of(context).size.width * 0.7,
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}

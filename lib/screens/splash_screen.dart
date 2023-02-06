import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';

import '../providers/products_notifier.dart';
import '../widgets/my_future_builder.dart';
import 'bottom_nav_bar_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFutureBuilder(
      fetchAndSetProductsFuture:
          context.read<ProductsNotifier>().getAndSetProducts(),
      onSuccessWidget: const BottomNavBarScreen(),
      onLoadingWidget: const _SplashScreen(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Center(
        child: Lottie.asset(
          'assets/animations/pharmacy.json',
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }
}

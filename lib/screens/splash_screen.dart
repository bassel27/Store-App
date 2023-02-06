import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_notifier.dart';
import 'bottom_nav_bar_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: Icons.medical_information_outlined,
      screenFunction: () async {
        await context.read<ProductsNotifier>().getAndSetProducts();
        return const BottomNavBarScreen();
      },
    );
  }
}

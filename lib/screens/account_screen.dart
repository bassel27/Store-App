import 'package:flutter/material.dart';
import 'package:store_app/screens/orders_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Orders"),
          onPressed: () {
            Navigator.pushNamed(context, OrdersScreen.route);
          },
        ),
      ),
    );
  }
}

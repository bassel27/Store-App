import 'package:flutter/material.dart';

import '../models/order/order.dart';
import '../widgets/cart_item_tile.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen();

  static const route = '';
  final myBorderSide = const BorderSide(color: Colors.grey, width: 2);
  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                right: myBorderSide, left: myBorderSide, top: myBorderSide),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: ListView(
              children: order.cartItems
                  .map((cartItem) => CartItemTile(cartItem: cartItem))
                  .toList()),
        ),
      ),
    );
  }
}

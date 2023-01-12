import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '.././widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;
import '.././widgets/total_container.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              builder: (__, cart, _) => ListView.builder(
                itemCount: cart.cartItemsCount,
                itemBuilder: (context, i) {
                  return CartTile(cart.items.values.toList()[i]);
                },
              ),
            ),
          ),
          TotalContainer(),
        ],
      ),
    );
  }
}

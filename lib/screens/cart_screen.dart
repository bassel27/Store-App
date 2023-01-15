import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_tile.dart';
import 'package:store_app/providers/cart_notifier.dart';
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
            child: Consumer<CartNotifier>(
              builder: (__, cart, _) => ListView.builder(
                itemCount: cart.cartItemsCount,
                itemBuilder: (context, i) {
                  //TODO: better way than searching to find id
                  return CartTile(cart.items.values.toList()[i],
                      cart.items.keys.toList()[i]);
                },
              ),
            ),
          ),
          const TotalContainer(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';

import '.././widgets/total_container.dart';
import '../models/cart_item.dart';
import '../widgets/cart_tile.dart';

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
              builder: (__, CartNotifier cartProvider, _) => ListView.builder(
                itemCount: cartProvider.cartItemsCount,
                itemBuilder: (context, i) {
                  //TODO: better way than searching to find id
                  CartItem cartItem = cartProvider.items[i];
                  return CartTile(cartItem, cartItem.product.id);
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

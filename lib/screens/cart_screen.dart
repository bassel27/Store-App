import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '.././widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
        child: Column(
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
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total"),
                    const Spacer(),
                    Consumer<Cart>(
                      builder: (__, cart, _) => Chip(
                        label: Text("${cart.total}"),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Order Now"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

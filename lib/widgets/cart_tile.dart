import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';

import '../models/cart_item.dart';

class CartTile extends StatelessWidget {
  final CartItem cartItem;
  final String productId;
  const CartTile(this.cartItem, this.productId);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifier>(
      builder: (context, cart, child) => Dismissible(
        onDismissed: (_) {
          cart.removeItem(cartItem.id);
        },
        key: ValueKey(cartItem.id),
        background: Container(
          padding: const EdgeInsets.only(right: 15),
          color: Theme.of(context).errorColor,
          child: const Align(
              alignment: Alignment.centerRight, child: Icon(Icons.delete)),
        ),
        direction: DismissDirection.endToStart,
        child: child as Widget,
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom:
                BorderSide(width: 2, color: Color.fromRGBO(116, 102, 102, .5)),
          ),
        ),
        child: ListTile(
          title: Text(cartItem.name),
          subtitle: Text(
              "Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}"),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          trailing: Text("${cartItem.quantity}x"),
        ),
      ),
    );
  }
}

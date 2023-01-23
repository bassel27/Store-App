import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/widgets/my_dismissble.dart';

import '../models/cart_item.dart';
import '../providers/cart_notifier.dart';

class CartTile extends StatelessWidget {
  final CartItem cartItem;
  final String productId;
  const CartTile(this.cartItem, this.productId);

  @override
  Widget build(BuildContext context) {
    return MyDismissible(
      valueKeyId: cartItem.id,
      onDismissed: (_) {
        var cart = Provider.of<CartNotifier>(context, listen: false);
        cart.removeItem(cartItem.id);
      },
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

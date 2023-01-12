import 'package:flutter/material.dart';

import '../providers/cart.dart';

class CartTile extends StatelessWidget {
  final CartItem cartItem;
  CartTile(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(cartItem.name),
        subtitle:
            Text("Total: \$${(cartItem.price * cartItem.quantity).toString()}"),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        trailing: Text("${cartItem.quantity}x"),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                "\$${cartItem.price.toString()}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

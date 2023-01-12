import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartTile extends StatelessWidget {
  final CartItem cartItem;
  CartTile(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) => Dismissible(
        onDismissed: (_) {
          cart.removeItem(cartItem.id);
        },
        key: ValueKey(cartItem.id),
        background: Container(
          padding: EdgeInsets.only(right: 15),
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
              "Total: \$${(cartItem.price * cartItem.quantity).toString()}"),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import 'package:store_app/widgets/my_dismissble.dart';

import '../models/cart_item/cart_item.dart';
import '../providers/cart_notifier.dart';

class CartTile extends StatelessWidget {
  final CartItem cartItem;

  const CartTile(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return MyDismissible(
      valueKeyId: cartItem.id,
      onDismissed: (_) {
        var cart = Provider.of<CartNotifier>(context, listen: false);
        cart.deleteItem(cartItem);
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom:
                BorderSide(width: 2, color: Color.fromRGBO(116, 102, 102, .5)),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.route,
                arguments: cartItem.product);
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(cartItem.product.imageUrl),
            ),
            title: Text(
              cartItem.product.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            subtitle: Text(
                "Total: $kCurrency ${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}"),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            trailing: Text("${cartItem.quantity}x"),
          ),
        ),
      ),
    );
  }
}

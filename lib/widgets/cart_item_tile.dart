import 'package:flutter/material.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/widgets/product_circle_avatar.dart';

import '../models/cart_item/cart_item.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Hero(
              tag: cartItem.product.id,
              child: ProductCircleAvatar(
                product: cartItem.product,
              )),
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
        const Divider(
          thickness: 1,
        )
      ],
    );
  }
}

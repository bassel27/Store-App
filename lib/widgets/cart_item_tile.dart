import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/widgets/product_circle_avatar.dart';

import '../models/cart_item/cart_item.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    Key? key,
    required this.cartItem,
    this.isHeroAnimationOn = false,
  }) : super(key: key);
  final bool isHeroAnimationOn;
  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: isHeroAnimationOn
              ? Hero(
                  tag: cartItem.product.id,
                  child: ProductCircleAvatar(
                    product: cartItem.product,
                  ))
              : ProductCircleAvatar(
                  product: cartItem.product,
                ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${cartItem.product.title} ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                TextSpan(
                  text: "${cartItem.size} x${cartItem.quantity}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ],
            ),
          ),
          subtitle: Text(
              "Total: $kCurrency ${(cartItem.product.price * Decimal.parse(cartItem.quantity.toString())).toStringAsFixed(2)}"),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          trailing: isHeroAnimationOn
              ? Expanded(
                  child: IconButton(
                      onPressed: () {
                        var cart =
                            Provider.of<CartNotifier>(context, listen: false);
                        cart.deleteItem(cartItem);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      )),
                )
              : null,
        ),
        const Divider(
          thickness: 1,
        )
      ],
    );
  }
}

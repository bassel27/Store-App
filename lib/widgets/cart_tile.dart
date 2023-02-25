import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import 'package:store_app/widgets/my_dismissble.dart';

import '../models/cart_item/cart_item.dart';
import '../providers/cart_notifier.dart';
import 'cart_item_tile.dart';

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
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetailScreen.route,
              arguments: cartItem.product);
        },
        child: CartItemTile(cartItem: cartItem),
      ),
    );
  }
}

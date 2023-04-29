import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/screens/product_details_screen.dart';
import 'package:store_app/widgets/empty_screen_text.dart';

import '.././widgets/total_container.dart';
import '../models/cart_item/cart_item.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/my_dismissble.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _SuccessfulScaffoldBody();
  }
}

class _SuccessfulScaffoldBody extends StatelessWidget {
  const _SuccessfulScaffoldBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifier>(
      builder: (__, CartNotifier cartProvider, _) => cartProvider.items.isEmpty
          ? const EmptyScreenText('Cart is empty')
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItemsCount,
                    itemBuilder: (context, i) {
                      //TODO: better way than searching to find id
                      CartItem cartItem = cartProvider.items[i];
                      return MyDismissible(
                        valueKeyId: cartItem.id,
                        onDismissed: (_) {
                          var cart =
                              Provider.of<CartNotifier>(context, listen: false);
                          cart.deleteItem(cartItem);
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ProductDetailsScreen.route,
                                arguments: cartItem.product);
                          },
                          child: CartItemTile(
                            cartItem: cartItem,
                            isHeroAnimationOn: false,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TotalContainer(),
              ],
            ),
    );
  }
}

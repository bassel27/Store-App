import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/screens/product_details_screen.dart';

import '.././widgets/total_container.dart';
import '../models/cart_item/cart_item.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/exception_scaffold_body.dart';
import '../widgets/my_dismissble.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future _future;
  @override
  void initState() {
    super.initState();
    _future = lol();
  }

  Future<void> lol() {
    CartNotifier cartProvider =
        Provider.of<CartNotifier>(context, listen: false);
    if (!cartProvider.isCartFetched) {
      return cartProvider.getAndSetCart();
    } else {
      return Future.delayed(Duration.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Center(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ExceptionScaffoldBody(snapshot.error as Exception);
              } else {
                return const _SuccessfulScaffoldBody();
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}

class _SuccessfulScaffoldBody extends StatelessWidget {
  const _SuccessfulScaffoldBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<CartNotifier>(
            builder: (__, CartNotifier cartProvider, _) => ListView.builder(
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
                      Navigator.pushNamed(context, ProductDetailsScreen.route,
                          arguments: cartItem.product);
                    },
                    child: CartItemTile(
                      cartItem: cartItem,
                      isHeroAnimationOn: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        TotalContainer(),
      ],
    );
  }
}

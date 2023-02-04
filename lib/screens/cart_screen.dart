import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/widgets/fetch_and_set_products_future.dart';

import '.././widgets/total_container.dart';
import '../models/cart_item.dart';
import '../widgets/cart_tile.dart';

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
      body: GetAndSetFutureBuilder(
        fetchAndSetProductsFuture: _future,
        successfulScaffoldBody: Column(
          children: [
            Expanded(
              child: Consumer<CartNotifier>(
                builder: (__, CartNotifier cartProvider, _) => ListView.builder(
                  itemCount: cartProvider.cartItemsCount,
                  itemBuilder: (context, i) {
                    //TODO: better way than searching to find id
                    CartItem cartItem = cartProvider.items[i];
                    return CartTile(cartItem, cartItem.product.id);
                  },
                ),
              ),
            ),
            TotalContainer(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';

import '.././widgets/total_container.dart';

import '../models/cart_item/cart_item.dart';
import '../widgets/cart_tile.dart';
import '../widgets/my_future_builder.dart';

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
    return ScaffoldFutureBuilder(
      appBar: AppBar(title: const Text("Cart")),
      fetchAndSetProductsFuture: _future,
      onSuccessWidget: const _SuccessfulScaffoldBody(),
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
                return CartTile(cartItem, cartItem.product.id);
              },
            ),
          ),
        ),
        TotalContainer(),
      ],
    );
  }
}

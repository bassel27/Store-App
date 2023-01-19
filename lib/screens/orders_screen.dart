import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/widgets/order_list_tile.dart';

import '../widgets/empty_screen_text.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const route = "/my_account/order_screen";
  @override
  Widget build(BuildContext context) {
    var ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: ordersProvider.numberOfOrders == 0
          ? EmptyScreenText("No orders")
          : ListView.builder(
              itemCount: ordersProvider.numberOfOrders,
              itemBuilder: (_, i) => OrderListTile(ordersProvider.orders[i]),
            ),
    );
  }
}



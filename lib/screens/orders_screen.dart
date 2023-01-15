import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/orders.dart';
import 'package:store_app/widgets/order_list_tile.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const route = "/my_account/order_screen";
  @override
  Widget build(BuildContext context) {
    var ordersNotifier = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: ordersNotifier.numberOfOrders == 0
          ? Text("No ordres")
          : ListView.builder(
              itemCount: ordersNotifier.numberOfOrders,
              itemBuilder: (_, i) => OrderListTile(ordersNotifier.orders[i]),
            ),
    );
  }
}

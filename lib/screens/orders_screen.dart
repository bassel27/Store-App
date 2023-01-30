import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/widgets/order_list_tile.dart';

import '../widgets/empty_screen_text.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const route = "/my_account/order_screen";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture =
        Provider.of<OrdersNotifier>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
        ),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                var ordersProvider = Provider.of<OrdersNotifier>(context);
                return ordersProvider.numberOfOrders == 0
                    ? const EmptyScreenText("No orders")
                    : ListView.builder(
                        itemCount: ordersProvider.numberOfOrders,
                        itemBuilder: (_, i) =>
                            OrderListTile(ordersProvider.orders[i]));
              }
            }
          },
        ));
  }
}

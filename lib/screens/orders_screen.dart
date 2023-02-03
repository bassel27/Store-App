import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/widgets/error_scaffold_body.dart';
import 'package:store_app/widgets/order_list_tile.dart';

import '../widgets/empty_screen_text.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const route = "/my_account/order_screen";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _lol;
  @override
  void initState() {
    super.initState();
    _lol = lol();
  }

  Future<void> lol() {
    return Provider.of<OrdersNotifier>(context, listen: false)
        .getAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
        ),
        body: Center(
          child: FutureBuilder(
            future: _lol,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return ErrorScaffoldBody(snapshot.error as Exception);
                } else {
                  return _SuccessfulScaffoldBody();
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
        ));
  }
}

class _SuccessfulScaffoldBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ordersProvider = Provider.of<OrdersNotifier>(context);
    return ordersProvider.numberOfOrders == 0
        ? const EmptyScreenText("No orders")
        : ListView.builder(
            itemCount: ordersProvider.numberOfOrders,
            itemBuilder: (_, i) => OrderListTile(ordersProvider.orders[i]),
          );
  }
}

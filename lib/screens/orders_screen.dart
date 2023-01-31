import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/controllers/orders_controller.dart';
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
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // _ordersFuture =
    //     Provider.of<OrdersNotifier>(context, listen: false).fetchAndSetOrders();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrdersController().fetchOrders().then((orders) {
        Provider.of<OrdersNotifier>(context, listen: false).orders = orders;
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var ordersProvider = Provider.of<OrdersNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ordersProvider.numberOfOrders == 0
              ? const EmptyScreenText("No orders")
              : ListView.builder(
                  itemCount: ordersProvider.numberOfOrders,
                  itemBuilder: (_, i) =>
                      OrderListTile(ordersProvider.orders[i]),
                ),
    );
  }
}

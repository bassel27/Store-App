import 'package:flutter/material.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:provider/provider.dart';

import '../../data/models/order/order.dart';
import '../notifiers/orders_notifier.dart';
import '../notifiers/user_notifier.dart';
import '../widgets/empty_screen_text.dart';
import '../widgets/exception_scaffold_body.dart';
import '../widgets/order_list_tile.dart';


class OrdersScreen extends StatelessWidget {
  static const route = "/bottom_nav_bar/my_account/orders_screen";

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = context.read<UserNotifier>().currentUser!.isAdmin;
    var ordersProvider = Provider.of<OrdersNotifier>(context, listen: false);
    var currentOrders = ordersProvider.orders;
    return Scaffold(
        appBar: AppBar(
          title: Text(isAdmin ? "All Orders" : "Orders"),
        ),
        body: ordersProvider.areOrdersFetched
            ? ListView.builder(
              itemCount: currentOrders.length,
                itemBuilder: (_, i) => OrderListTile(currentOrders[i]),
              )
            : PaginationView<Order>(
                itemBuilder: (_, Order order, __) => OrderListTile(order),
                preloadedItems: const [],
                pageFetch: (currentListSize) async {
                  return await ordersProvider.getAndSetOrders(isAdmin);
                },
                onError: ((p0) => ExceptionScaffoldBody(p0)),
                onEmpty: const EmptyScreenText("No orders"),
              ));
  }
}

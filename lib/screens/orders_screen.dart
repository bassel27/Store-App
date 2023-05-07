import 'package:flutter/material.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/orders_notifier.dart';
import 'package:store_app/providers/user_notifier.dart';
import 'package:store_app/widgets/empty_screen_text.dart';
import 'package:store_app/widgets/exception_scaffold_body.dart';
import 'package:store_app/widgets/order_list_tile.dart';

import '../models/order/order.dart';

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

import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/mixins/add_token_to_url.dart';
import 'package:store_app/models/constants.dart';

import '../models/order/order.dart';
import '../providers/auth_notifier.dart';
import '../services/base_client.dart';

class OrdersController with ErrorHandler, AddTokenToUrl {
  AuthNotifier authProvider;
  OrdersController(this.authProvider);

  /// Returns fetched orders.
  ///
  /// Throws an exception if operation fails.
  Future<List<Order>> get() async {
    final List<Order> orders = [];
    Map<String, dynamic>? ordersMaps = await BaseClient.get(getTokenedUrl(
        url: "$kOrdersBaseUrl/${authProvider.userId}.json",
        token: authProvider.token!));

    if (ordersMaps != null) {
      // if there are orders.
      ordersMaps.forEach((_, orderData) {
        orders.add(Order.fromJson(orderData));
      });
    }
    orders
        .sort((a, b) => a.dateTime.toString().compareTo(b.dateTime.toString()));
    return orders.reversed.toList(); // newest first
  }

  /// Returns post ID and handles error using dialog.
  ///
  /// Throws exception if operation not successful.
  Future<void> create(Order newOrder) async {
    await BaseClient.put(
        getTokenedUrl(
            url: "$kOrdersBaseUrl/${authProvider.userId}/${newOrder.id}.json",
            token: authProvider.token!),
        newOrder.toJson());
  }
}

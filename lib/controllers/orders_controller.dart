import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/models/constants.dart';

import '../models/order/order.dart';
import '../services/base_client.dart';

class OrdersController with ErrorHandler {
  /// Returns fetched orders.
  ///
  /// Throws an exception if operation fails.
  Future<List<Order>> get() async {
    final List<Order> orders = [];
    Map<String, dynamic>? ordersMaps = await BaseClient.get(kOrdersUrl);
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
    await BaseClient.put(ordersUrlWithId(newOrder.id), newOrder.toJson());
  }

  String ordersUrlWithId(String id) {
    return "$kOrdersBaseUrl/$id.json";
  }
}

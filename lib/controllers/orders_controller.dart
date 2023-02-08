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
    if (ordersMaps != null) {   // if there are orders.
      ordersMaps.forEach((_, orderData) {
        orders.add(Order.fromJson(orderData));
      });
    }
    return orders.reversed.toList(); // newest first
  }

  /// Returns post ID and handles error using dialog.
  ///
  /// Throws exception if operation not successful.
  Future<void> create(Order newOrder) async {
    try {
      // TODO: makes new id??
      var response = await BaseClient.post(kOrdersUrl, newOrder.toJson());
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }
}

import 'package:store_app/controllers/base_controller.dart';
import 'package:store_app/models/constants.dart';

import '../models/order.dart';
import '../services/base_client.dart';

class OrdersController with BaseController {
  /// Returns fetched orders.
  ///
  /// Throws an exception if operation fails.
  Future<List<Order>> get() async {
    final List<Order> orders = [];
    Map<String, dynamic>? ordersMaps = await BaseClient.get(kOrdersUrl);
    if (ordersMaps != null) {
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
      var response = await BaseClient.post(kOrdersUrl, newOrder.toJson());
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }
}

import 'package:store_app/controllers/base_controller.dart';
import 'package:store_app/models/constants.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/base_client.dart';

class OrdersController with BaseController {
  /// Returns fetched orders, handles errors and loading.
  Future<List<Order>> get() async {
    Map<String, dynamic>? ordersExtractedData;
    try {
      ordersExtractedData = await BaseClient.get(kOrdersUrl);
    } catch (e) {
      rethrow;
    }

    final List<Order> loadedOrders = [];
    if (ordersExtractedData == null) {
      // if no orders exist
      return loadedOrders;
    }

    ordersExtractedData.forEach((orderId, orderData) {
      List<dynamic> productsMaps = orderData['products'];
      List<CartItem> cartItems = productsMaps
          .map((productMap) => CartItem.fromJson(productMap))
          .toList();
      loadedOrders.add(Order(
        id: orderId,
        total: orderData['total'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: cartItems,
      ));
    });

    return loadedOrders.reversed.toList(); // newest first
  }

  /// Returns post ID and handles errors.
  Future<String?> create(
      List<CartItem> cartItems, double total, DateTime nowTimeStamp) async {
    final payLoadInput = {
      'total': total,
      'dateTime': nowTimeStamp.toIso8601String(),
      'products': cartItems
          .map((cartItem) => {
                'id': cartItem.id,
                'title': cartItem.title,
                'quantity': cartItem.quantity,
                'price': cartItem.price,
              })
          .toList()
    };
    String? id;
    try {
      var response = await BaseClient.post(kOrdersUrl, payLoadInput);
      id = response.body;
    } catch (e) {
      handleError(e);
      return null;
    }
    return id;
  }
}

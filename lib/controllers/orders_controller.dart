import 'package:store_app/controllers/base_controller.dart';
import 'package:store_app/models/constants.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';
import '../services/base_client.dart';

class OrdersController with BaseController {
  /// Returns fetched orders, handles errors and loading.
  Future<List<OrderItem>> get() async {
    Map<String, dynamic>? ordersExtractedData;
    try {
      ordersExtractedData = await BaseClient.get(kOrdersUrl);
    } catch (e) {
      rethrow;
    }

    final List<OrderItem> loadedOrders = [];
    if (ordersExtractedData == null) {
      // if no orders exist
      return loadedOrders;
    }

    ordersExtractedData.forEach((orderId, orderData) {
      List<dynamic> productsMaps = orderData['products'];
      List<CartItem> cartItems = productsMaps
          .map((productMap) => CartItem.fromJson(productMap))
          .toList();
      loadedOrders.add(OrderItem(
        id: orderId,
        quantity: orderData['quantity'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: cartItems,
      ));
    });

    return loadedOrders.reversed.toList(); // newest first
  }

  /// Returns post ID and handles errors.
  Future<String?> create(
      List<CartItem> cartProducts, double total, DateTime nowTimeStamp) async {
    final payLoadInput = {
      'quantity': total,
      'dateTime': nowTimeStamp.toIso8601String(),
      'products': cartProducts
          .map((cartProduct) => {
                'id': cartProduct.id,
                'title': cartProduct.title,
                'quantity': cartProduct.quantity,
                'price': cartProduct.price,
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

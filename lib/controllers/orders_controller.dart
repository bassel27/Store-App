import 'package:store_app/controllers/base_controller.dart';
import 'package:store_app/models/constants.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';
import '../services/base_client.dart';

class OrdersController with BaseController {
  Future<List<OrderItem>> fetchOrders() async {
    Map<String, dynamic>? ordersExtractedData = await BaseClient.get(kOrdersUrl)
        .catchError(handleError) as Map<String, dynamic>?;
    final List<OrderItem> loadedOrders = [];
    if (ordersExtractedData == null) {
      return [];
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
    //TDOO: return empty list even if fetching failed?
    return loadedOrders.reversed.toList(); // newest first
  }
}

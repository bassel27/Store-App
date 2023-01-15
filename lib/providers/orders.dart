import 'package:flutter/cupertino.dart';
import 'package:store_app/providers/cart.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';

class Orders with ChangeNotifier {
  /// List of all order sorted by recency.
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];
  int get numberOfOrders => _orders.length;
  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}

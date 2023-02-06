import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../controllers/orders_controller.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrdersNotifier with ChangeNotifier {
  /// List of all order sorted by recency.
  List<Order> _orders = [];

  final OrdersController _ordersController = OrdersController();
  List<Order> get orders => UnmodifiableListView(_orders);
  set orders(List<Order> orders) {
    _orders = orders;
  }

  int get numberOfOrders => _orders.length;
  Future<void> getAndSetOrders() async {
    try {
      _orders = await _ordersController.get();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
  /// Throws an exception if operation not successful.
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final nowTimeStamp = DateTime.now();

    String id =
        await _ordersController.create(cartProducts, total, nowTimeStamp);
    _orders.insert(
      0,
      Order(
        id: id,
        total: total,
        products: cartProducts,
        dateTime: nowTimeStamp,
      ),
    );
    notifyListeners();
  }
}

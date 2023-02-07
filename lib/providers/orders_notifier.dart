import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

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

  /// Throws exception if fails.
  Future<void> getAndSetOrders() async {
    _orders = await _ordersController.get();
    notifyListeners();
  }

  /// Throws an exception if operation not successful.
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final Order newOrder = Order(
      id: const Uuid().v4(),
      total: total,
      cartItems: cartProducts,
      dateTime: DateTime.now(),
    );
    await _ordersController.create(newOrder);
    _orders.insert(
      0,
      newOrder,
    );
    notifyListeners();
  }
}

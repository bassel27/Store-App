import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../controllers/orders_controller.dart';
import '../models/cart_item.dart';
import '../models/order_item.dart';

class Failure {
  String message;

  Failure(this.message);
  @override
  String toString() {
    return message;
  }
}

class OrdersNotifier with ChangeNotifier {
  /// List of all order sorted by recency.
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => UnmodifiableListView(_orders);
  set orders(List<OrderItem> orders) {
    _orders = orders;
  }

  int get numberOfOrders => _orders.length;
  Future<void> getAndSetOrders() async {
    _orders = await OrdersController().get();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final nowTimeStamp = DateTime.now();
    String? id =
        await OrdersController().create(cartProducts, total, nowTimeStamp);
    if (id != null) {
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(id)["name"],
          quantity: total,
          products: cartProducts,
          dateTime: nowTimeStamp,
        ),
      );
      notifyListeners();
    }
  }
}

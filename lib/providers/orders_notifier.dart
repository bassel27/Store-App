import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/excpetion_handler.dart';
import 'package:uuid/uuid.dart';

import '../controllers/order_controller.dart';
import '../models/cart_item/cart_item.dart';
import '../models/order/order.dart';
import '../models/user/user.dart';

class OrdersNotifier with ChangeNotifier, ExceptionHandler {
  /// List of all order sorted by recency.
  // TODO: make private
  List<Order> _orders = [];

  OrdersNotifier();

  late final OrderController _ordersController = OrderController();

  List<Order> get orders => _orders;

  set orders(List<Order> orders) {
    _orders = orders;
  }

  int get numberOfOrders => _orders.length;

  bool areOrdersFetched = false;

  /// Returns newly fetched orders.
  Future<List<Order>> getAndSetOrders(bool isAdmin,
      {int numberOfOrdersToFetch = 5}) async {
    List<Order> newOrders = await _ordersController.getOrdersByBatch(
        isAdmin, numberOfOrdersToFetch);

    _orders.addAll(newOrders);
    if (newOrders.isEmpty) {
      // all orders have been fetched
      areOrdersFetched = true;
    }
    notifyListeners();
    return newOrders;
  }

  /// Throws an exception if operation not successful.
  Future<void> addOrder(
      List<CartItem> cartProducts, double total, User user) async {
    final Order newOrder = Order(
        id: const Uuid().v4(),
        total: Decimal.parse(total.toString()),
        cartItems: cartProducts,
        dateTime: DateTime.now(),
        userId: user.id,
        address: user.address!);
    await _ordersController.create(newOrder).then((_) => _orders.insert(
          0,
          newOrder,
        ));

    notifyListeners();
  }

  // called when user logs out to reset all provider's data
  void reset() {
    _orders = [];
    areOrdersFetched = false;
  }
}

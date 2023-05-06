import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/excpetion_handler.dart';
import 'package:uuid/uuid.dart';

import '../controllers/order_controller.dart';
import '../models/cart_item/cart_item.dart';
import '../models/order/order.dart';

class OrdersNotifier with ChangeNotifier, ExceptionHandler {
  /// List of all order sorted by recency.
  // TODO: make private
  List<Order> _orders=[];

  OrdersNotifier();

  late final OrderController _ordersController = OrderController();

  List<Order> get orders => [..._orders]..sort((a, b) {
      return b.dateTime.compareTo(a.dateTime);
    });

  set orders(List<Order> orders) {
    _orders = orders;
  }

  int get numberOfOrders => _orders.length;

  bool areOrdersFetched = false;

  /// Throws exception if fails.
  Future<void> getAndSetOrders(bool isAdmin) async {
    _orders = await _ordersController.get(isAdmin);
    notifyListeners();
  }

  /// Throws an exception if operation not successful.
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final Order newOrder = Order(
        id: const Uuid().v4(),
        total: total,
        cartItems: cartProducts,
        dateTime: DateTime.now(),
        userId: FirebaseAuth.instance.currentUser!.uid);
    await _ordersController.create(newOrder).then((_) => _orders.insert(
          0,
          newOrder,
        ));

    notifyListeners();
  }
}

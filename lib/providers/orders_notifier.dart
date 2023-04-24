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
  List<Order> ordersList;

  OrdersNotifier(this.ordersList);

  late final OrderController _ordersController = OrderController();

  List<Order> get orders => [...ordersList]..sort((a, b) {
      return b.dateTime.compareTo(a.dateTime);
    });

  set orders(List<Order> orders) {
    ordersList = orders;
  }

  int get numberOfOrders => ordersList.length;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  /// Checks if orders have been fetched for the current user or not.
  get areOrdersFetched {
    return currentUserId != FirebaseAuth.instance.currentUser!.uid;
  }

  /// Throws exception if fails.
  Future<void> getAndSetOrders(bool isAdmin) async {
    ordersList = await _ordersController.get(isAdmin);
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
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
    await _ordersController
        .create(newOrder)
        .then((_) => ordersList.insert(
              0,
              newOrder,
            ))
        .catchError(handleException);

    notifyListeners();
  }
}

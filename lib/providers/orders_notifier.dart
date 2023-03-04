import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/error_handler.dart';
import 'package:uuid/uuid.dart';

import '../controllers/orders_controller.dart';
import '../models/cart_item/cart_item.dart';
import '../models/order/order.dart';

class OrdersNotifier with ChangeNotifier, ErrorHandler {
  /// List of all order sorted by recency.
  // TODO: make private
  List<Order> ordersList;

  OrdersNotifier(this.ordersList);

  late final OrdersController _ordersController = OrdersController();
  List<Order> get orders => [...ordersList];
  set orders(List<Order> orders) {
    ordersList = orders;
  }

  int get numberOfOrders => ordersList.length;
  bool areOrdersFetched = false;

  /// Throws exception if fails.
  Future<void> getAndSetOrders() async {
    ordersList = await _ordersController.get();
    areOrdersFetched = true;
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
    await _ordersController
        .create(newOrder)
        .then((_) => ordersList.insert(
              0,
              newOrder,
            ))
        .catchError(handleError);

    notifyListeners();
  }
}

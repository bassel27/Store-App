import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/models/constants.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';
import '../services/base_client.dart';

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
  int get numberOfOrders => _orders.length;
  // TODO: error handling
  Future<void> fetchAndSetOrders() async {
    Map<String, dynamic>? ordersExtractedData =
        await BaseClient.get(kOrdersUrl) as Map<String, dynamic>?;
    final List<OrderItem> loadedOrders = [];
    if (ordersExtractedData == null) {
      return;
    }

    ordersExtractedData.forEach((orderId, orderData) {
      List<dynamic> productsMaps = orderData['products'];
      List<CartItem> cartItems = productsMaps
          .map((productMap) => CartItem.fromJson(
                productMap
              ))
          .toList();
      loadedOrders.add(OrderItem(
        id: orderId,
        quantity: orderData['quantity'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: cartItems,
      ));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

//TODO: error handling
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final nowTimeStamp = DateTime.now();
    final response = await http.post(kOrdersUri,
        body: json.encode({
          'quantity': total,
          'dateTime': nowTimeStamp.toIso8601String(),
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)["name"],
        quantity: total,
        products: cartProducts,
        dateTime: nowTimeStamp,
      ),
    );
    notifyListeners();
  }
}

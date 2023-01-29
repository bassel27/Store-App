import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/models/constants.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';

class Orders with ChangeNotifier {
  /// List of all order sorted by recency.
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];
  int get numberOfOrders => _orders.length;
//TODO: error handling
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final nowTimeStamp = DateTime.now();
    final response = await http.post(kOrdersUrl,
        body: json.encode({
          'amount': total,
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'name': cartProduct.name,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                  })
              .toList(),
          'dateTime': nowTimeStamp.toIso8601String(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)["name"],
        amount: total,
        products: cartProducts,
        dateTime: nowTimeStamp,
      ),
    );
    notifyListeners();
  }
}

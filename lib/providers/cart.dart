import 'package:flutter/cupertino.dart';

import '../models/cart_item.dart';



class Cart with ChangeNotifier {
  /// Key is productId and value is cartItem.
  late Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get items {
    return {..._cartItems};
  }

  get cartItemsCount {
    return _cartItems.length;
  }

  get total {
    double total = 0.00;
    _cartItems.forEach((productId, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
      final String productId, final String productName, final double price) {
    _cartItems.update(
      productId,
      (oldCartItem) {
        return CartItem(
            id: oldCartItem.id,
            name: oldCartItem.name,
            price: oldCartItem.price,
            quantity: oldCartItem.quantity + 1);
      },
      ifAbsent: () {
        return CartItem(
            id: DateTime.now().toString(),
            name: productName,
            quantity: 1,
            price: price);
      },
    );
    notifyListeners();
  }

  void removeItem(cartItemId) {
    _cartItems.removeWhere((_, cartItem) => cartItemId == cartItem.id);
    notifyListeners();
  }
}

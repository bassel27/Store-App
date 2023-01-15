import 'package:flutter/cupertino.dart';

import '../models/cart_item.dart';

class CartNotifier with ChangeNotifier {
  
  /// Key is productId and value is cartItem.
  late Map<String, CartItem> _items = {};

  // A list of all products placed in cart.
  Map<String, CartItem> get items {
    return {..._items};
  }

  /// Number of products placed in cart.
  get cartItemsCount {
    return _items.length;
  }

  /// Cart total amount.
  get total {
    double total = 0.00;
    _items.forEach((productId, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
      final String productId, final String productName, final double price) {
    _items.update(
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

  /// Removes an item from the cart using this item's id.
  void removeItem(cartItemId) {
    _items.removeWhere((_, cartItem) => cartItemId == cartItem.id);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void clear() {
    _items = {};
    notifyListeners();
  }
}

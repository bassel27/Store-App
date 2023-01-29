import 'package:flutter/cupertino.dart';

import '../models/cart_item.dart';

class CartNotifier with ChangeNotifier {
  //TODO: remove productID if not used and convert it to a list
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

  /// Adds a new product to cart or increases the quantity of an already existing one.
  void addItem(
      final String productId, final String productName, final double price) {
    _items.update(
      productId,
      (oldCartItem) {
        return CartItem(
            id: oldCartItem.id,
            title: oldCartItem.title,
            price: oldCartItem.price,
            quantity: oldCartItem.quantity + 1);
      },
      ifAbsent: () {
        return CartItem(
            id: DateTime.now().toString(),
            title: productName,
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

  /// Subtracts one from the quantity of that item or removes the item totally if called while quantity was 1.
  void removeSingleItem(cartItemId) {
    for (var cartItem in _items.values.toList()) {
      if (cartItem.id == cartItemId) {
        if (cartItem.quantity > 1) {
          cartItem.quantity -= 1;
        } else {
          _items.removeWhere((_, cartItem) => cartItem.id == cartItemId);
        }
        notifyListeners();
        break;
      }
    }
    return;
  }

  /// Removes all items from the cart.
  void clear() {
    _items = {};
    notifyListeners();
  }
}

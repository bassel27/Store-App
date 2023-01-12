import 'package:flutter/cupertino.dart';

class CartItem {
  final String _id;
  final String _name;
  final int _quantity;
  final double _price;

  CartItem(
      {required String id,
      required String name,
      required int quantity,
      required double price})
      : _id = id,
        _name = name,
        _quantity = quantity,
        _price = price;
  get id {
    return _id;
  }

  get name {
    return _name;
  }

  get quantity {
    return _quantity;
  }

  get price {
    return _price;
  }
}

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

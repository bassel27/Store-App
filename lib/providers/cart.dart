import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  /// Key is productId.
  late Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get items {
    return {..._cartItems};
  }

  get cartItemsCount {
    return _cartItems.length;
  }

  void addItem(
      final String productId, final String productName, final double price) {
    if (_cartItems.containsKey(productId)) {
      // TODO: use ifabscent here
      _cartItems.update(
        productId,
        (oldCartItem) => CartItem(
            id: oldCartItem.id,
            name: oldCartItem.name,
            price: oldCartItem.price,
            quantity: oldCartItem.quantity + 1),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            name: productName,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }
}

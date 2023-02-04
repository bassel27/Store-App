import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/cart_controller.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartNotifier with ChangeNotifier {
  //TODO: remove productID if not used and convert it to a list
  /// Key is productId and value is cartItem.
  late List<CartItem> _cartItems = [];
  final CartController _cartController = CartController();
  // A list of all products placed in cart.
  List<CartItem> get items {
    return UnmodifiableListView(_cartItems);
  }

  /// Number of products placed in cart.
  get cartItemsCount {
    return _cartItems.length;
  }

  /// Cart total amount.
  double get total {
    double total = 0.00;
    for (var cartItem in _cartItems) {
      total += cartItem.product.price * cartItem.quantity;
    }

    return total;
  }

  CartItem? getCartItem(Product product) {
    for (CartItem cartItem in _cartItems) {
      if (cartItem.product.id == product.id) {
        return cartItem;
      }
    }
    return null;
  }

  /// Adds a new product to cart or increases the quantity of an already existing one.
  void add(Product product) async {
    for (CartItem cartItem in _cartItems) {
      if (cartItem.product.id == product.id) {
        cartItem = cartItem.copyWith(quantity: cartItem.quantity + 1);
        return;
      }
    }
    CartItem newCartItem =
        CartItem(id: const Uuid().v4(), product: product, quantity: 1);
    _cartItems.add(newCartItem);
    notifyListeners();
    try {
      await _cartController.create(newCartItem);
    } catch (e) {
      // if product doesn't exist in cart
      _cartItems.remove(newCartItem);
      notifyListeners();
      rethrow;
    }
  }

  /// Removes an item from the cart using this item's id.
  void removeItem(CartItem cartItemInput) {
    _cartItems.removeWhere((cartItem) => cartItemInput.id == cartItem.id);
    notifyListeners();
  }

  /// Subtracts one from the quantity of that item or removes the item totally if called while quantity was 1.
  void removeSingleItem(CartItem cartItemInput) {
    for (CartItem cartItem in _cartItems) {
      if (cartItem.id == cartItemInput.id) {
        if (cartItem.quantity == 1) {
          _cartItems.removeWhere((cartItem) => cartItem.id == cartItemInput.id);
        } else {
          cartItem.copyWith(quantity: cartItem.quantity - 1);
        }
        notifyListeners();
        break;
      }
    }
    return;
  }

  /// Removes all items from the cart.
  void clear() {
    _cartItems = [];
    notifyListeners();
  }
}

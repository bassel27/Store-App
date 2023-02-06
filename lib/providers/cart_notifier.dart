import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/cart_controller.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartNotifier with ChangeNotifier {
  /// Delete an item from the cart using this item's id.
  void deleteItem(CartItem cartItemInput) {
    _items.removeWhere((cartItem) => cartItemInput.id == cartItem.id);
    notifyListeners();
  }

  bool isCartFetched = false;
  //TODO: remove productID if not used and convert it to a list
  /// Key is productId and value is cartItem.
  late List<CartItem> _items = [];
  final CartController _cartController = CartController();
  // A list of all products placed in cart.
  List<CartItem> get items {
    return UnmodifiableListView(_items);
  }

  /// Number of products placed in cart.
  get cartItemsCount {
    return _items.length;
  }

  /// Cart total amount.
  double get total {
    double total = 0.00;
    for (var cartItem in _items) {
      total += cartItem.product.price * cartItem.quantity;
    }

    return total;
  }

  Future<bool> optimisticUpdate(
      {Function? function1,
      required Function mayFailFunction,
      required Function onFailure}) async {
    if (function1 != null) function1();
    notifyListeners();
    try {
      await mayFailFunction();
      return true;
    } catch (e) {
      onFailure();
      notifyListeners();
      return false;
    }
  }

  CartItem? getCartItem(Product product) {
    for (CartItem cartItem in _items) {
      if (cartItem.product.id == product.id) {
        return cartItem;
      }
    }
    return null;
  }

  Future<void> getAndSetCart() async {
    List<CartItem>? items = await _cartController.get();
    _items = items;
    notifyListeners();
    isCartFetched = true;
  }

  void increment(CartItem cartItem) {
    cartItem = cartItem.copyWith(quantity: cartItem.quantity + 1);
  }

  /// Adds a new product to cart or increases the quantity of an already existing one.
  void add(Product product) async {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].product.id == product.id) {
        try {
          await _cartController.incrementQuantity(_items[i]);
          _items[i] = _items[i].copyWith(quantity: _items[i].quantity + 1);
          notifyListeners();
        } catch (e) {
          // so that second line doesn't execute if incrementing fails}
        }
        return;
      }
    }
    // create new cartItem with quantity of 1
    CartItem newCartItem =
        CartItem(id: const Uuid().v4(), product: product, quantity: 1);

    try {
      await _cartController.create(newCartItem);
      _items.add(newCartItem);
      notifyListeners();
    } catch (e) {}
  }

  /// Subtracts one from the quantity of that item or removes the item totally if called while quantity was 1.
  void decrementQuantity(CartItem cartItemInput) async {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].id == cartItemInput.id) {
        if (_items[i].quantity == 1) {
          CartItem removedProduct = _items[i];
          optimisticUpdate(function1: () {
            _items.removeWhere((cartItem) => cartItem.id == cartItemInput.id);
          }, mayFailFunction: () async {
            await _cartController.delete(removedProduct);
          }, onFailure: () {
            _items.add(removedProduct);
          });
        } else {
          _items[i] = _items[i].copyWith(quantity: _items[i].quantity - 1);
          optimisticUpdate(mayFailFunction: () async {
            await _cartController.decrementQuantity(cartItemInput);
          }, onFailure: () {
            _items[i] = _items[i].copyWith(quantity: _items[i].quantity + 1);
          });
        }
        notifyListeners();
        break;
      }
    }
    return;
  }

  /// Removes all items from the cart.
  void clear() {
    _items = [];
    notifyListeners();
  }
}

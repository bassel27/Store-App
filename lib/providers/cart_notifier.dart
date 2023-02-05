import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/cart_controller.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartNotifier with ChangeNotifier {
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

  /// Adds a new product to cart or increases the quantity of an already existing one.
  void add(Product product) async {
    if (await incrementQuantityIfPossible(product)) {
      return;
    }
    // create new cartItem with quantity of 1
    CartItem newCartItem =
        CartItem(id: const Uuid().v4(), product: product, quantity: 1);
    _items.add(newCartItem);
    notifyListeners();
    try {
      await _cartController.create(newCartItem);
    } catch (e) {
      // decrement if the user preseed + right after cart or totally remove.
      decrementQuantity(newCartItem);
      notifyListeners();
    }
  }

  void optimisticUpdate(
      {Function? function1,
      required Function mayFailFunction,
      required Function onFailure}) async {
    if (function1 != null) function1();
    notifyListeners();
    try {
      await mayFailFunction();
    } catch (e) {
      onFailure();
      notifyListeners();
    }
  }

  /// Returns true if product found and incremented. Returns false if product not found.
  Future<bool> incrementQuantityIfPossible(product) async {
    // optimistic update
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].product.id == product.id) {
        _items[i] = _items[i].copyWith(quantity: _items[i].quantity + 1);
        optimisticUpdate(mayFailFunction: () async {
          await _cartController.incrementQuantity(_items[i]);
        }, onFailure: () {
          _items[i] = _items[i].copyWith(quantity: _items[i].quantity - 1);
        });
        return true;
      }
    }
    return false;
  }

  /// Removes an item from the cart using this item's id.
  void removeItem(CartItem cartItemInput) {
    _items.removeWhere((cartItem) => cartItemInput.id == cartItem.id);
    notifyListeners();
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

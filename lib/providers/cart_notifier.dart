import 'dart:collection';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/cart_controller.dart';
import 'package:uuid/uuid.dart';

import '../controllers/excpetion_handler.dart';
import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';

class CartNotifier with ChangeNotifier, ExceptionHandler {
  List<CartItem> _cartItems = [];
  CartNotifier();
  late final CartController _cartController = CartController();
  bool isCartFetched = false;

  //TODO: remove productID if not used and convert it to a list
  // TODO: make items private
  /// Key is productId and value is cartItem.

  // A list of all products placed in cart.
  List<CartItem> get items {
    return UnmodifiableListView(_cartItems);
  }

  /// Number of products placed in cart.
  get cartItemsCount {
    return _cartItems.length;
  }

  /// Cart total amount.
  Decimal get total {
    Decimal total = Decimal.parse('0');
    for (var cartItem in _cartItems) {
      total +=
          cartItem.product.price * Decimal.parse(cartItem.quantity.toString());
    }

    return total;
  }

  /// Returns true if the quantity is enough for the cartItem's quantity.
  ///
  /// If current quantity is zero, cartItem is removed from cart.
  /// This method should be called before ordering because cartItem's product doesn't get updated if a product changes.
  bool setUpdatedCartItemQuantity(CartItem cartItem, List<Product> products) {
    Product currentProduct;
    int index = items.indexOf(cartItem);
    if (products.contains(cartItem.product)) {
      currentProduct =
          products.firstWhere((element) => element.id == cartItem.product.id);
    } else {
      return false;
    }
    int? currentQuantity = currentProduct.sizeQuantity[cartItem.size];
    if (currentQuantity == null) {
      _cartItems.removeAt(index);
      notifyListeners();
      return false;
    } else if (currentQuantity >= cartItem.quantity) {
      return true;
    } else {
      _cartItems[index] = cartItem.copyWith(quantity: currentQuantity);
      notifyListeners();
      return false;
    }
  }

  Future<void> getAndSetCart() async {
    List<CartItem>? items = await _cartController.get();
    _cartItems = items;
    notifyListeners();
    isCartFetched = true;
  }

  /// Delete an item from the cart using this item's id.
  void deleteItem(CartItem cartItemInput) async {
    await _cartController.delete(cartItemInput.id).then((value) {
      _cartItems.removeWhere((cartItem) => cartItemInput.id == cartItem.id);
      notifyListeners();
    }).catchError(handleException);
  }

  Future<void> deleteCartItemsByProductId(String productId) async {
    await _cartController.deleteCartItemsByProductId(productId);
    _cartItems.removeWhere((cartItem) => productId == cartItem.product.id);
    notifyListeners();
  }

  // Increments the quantity of the CartItem if it exists in cart.
  void increment(CartItem cartItem) {
    int index = _cartItems.indexOf(cartItem);
    if (index != -1) {
      _cartItems[index] = cartItem.copyWith(quantity: cartItem.quantity + 1);
    }
  }

  // Decrements the quantity of the CartItem if it exists in cart.
  void decrement(CartItem cartItem) {
    int index = _cartItems.indexOf(cartItem);
    if (index != -1) {
      _cartItems[index] = cartItem.copyWith(quantity: cartItem.quantity - 1);
    }
  }

  Future<void> setQuantity(Product product, int quantity, String size) async {
    for (int i = 0; i < _cartItems.length; i++) {
      // if already exists in cart
      if (_cartItems[i].product.id == product.id &&
          size == _cartItems[i].size) {
        await _cartController
            .setQuantity(_cartItems[i], quantity)
            .then((value) {
          _cartItems[i] = _cartItems[i].copyWith(quantity: quantity);
        }).catchError(handleException);
        notifyListeners();
        return;
      }
    }

    CartItem newCartItem = CartItem(
        id: const Uuid().v4(),
        product: product,
        quantity: quantity,
        size: size);

    await _cartController
        .create(newCartItem)
        .then((_) => _cartItems.add(newCartItem))
        .catchError(handleException);
    notifyListeners();
  }

  /// Adds a new product to cart or increases the quantity of an already existing one.
  void add(Product product, String size) async {
    for (int i = 0; i < _cartItems.length; i++) {
      if (_cartItems[i].product.id == product.id &&
          _cartItems[i].size == size) {
        await _cartController
            .incrementQuantity(_cartItems[i])
            .then((value) => increment(_cartItems[i]))
            .catchError(handleException);
        notifyListeners();
        return;
      }
    }
    // create new cartItem with quantity of 1
    CartItem newCartItem = CartItem(
        id: const Uuid().v4(), product: product, quantity: 1, size: size);

    await _cartController
        .create(newCartItem)
        .then((_) => _cartItems.add(newCartItem))
        .catchError(handleException);
    notifyListeners();
  }

  /// Subtracts one from the quantity of that item or removes the item totally if called while quantity was 1.
  void decrementQuantity(CartItem cartItemInput) async {
    for (int i = 0; i < _cartItems.length; i++) {
      if (_cartItems[i].id == cartItemInput.id) {
        if (_cartItems[i].quantity == 1) {
          CartItem removedCartItem = _cartItems[i];
          await _cartController
              .delete(removedCartItem.id)
              .then((_) => _cartItems
                  .removeWhere((cartItem) => cartItem.id == cartItemInput.id))
              .catchError(handleException);
          notifyListeners();
        } else {
          await _cartController.decrementQuantity(cartItemInput).then((_) {
            decrement(_cartItems[i]);
          }).catchError(handleException);
          notifyListeners();
        }
        break;
      }
    }
    return;
  }

  /// Removes all items from the cart.
  Future<void> clear() async {
    await _cartController.clearCart(_cartItems);
    _cartItems = [];
    notifyListeners();
  }

  // called when user logs out to reset all provider's data
  void reset() {
    _cartItems = [];
  }
}

// TODO:  Here's what I would do. You're having foo1 handle the error and show an error dialog and it's caused you this pain. Instead of doing that, create a function for showing error dialogs. Add a try/catch block wherever execution must stop due to this error. Maybe it's the foo1, foo2 call, maybe it's even higher up in the call stack. (preferably higher up) Create a custom error called DialogableException Catch DialogableException and execute the function that creates the error dialog. DialogableException can be constructed with the error message to display. With this design you can halt for any error and the framework is in place for you to simply create error dialogs for the user by throwing an exception whenever you fail to handle something for the user. By having a custom exception you don't catch asserts or other real errors that may happen. I believe this scales better than the bool, but if you don't need this kind of framework because you don't expect to have to show dialogs for other stuff then a simple bool is okay.

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/cart_controller.dart';
import 'package:uuid/uuid.dart';

import '../controllers/error_handler.dart';
import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';

class CartNotifier with ChangeNotifier, ErrorHandler {
  String authToken;
  List<CartItem> cartItems;
  CartNotifier(this.authToken, this.cartItems);

  /// Delete an item from the cart using this item's id.
  void deleteItem(CartItem cartItemInput) {
    cartItems.removeWhere((cartItem) => cartItemInput.id == cartItem.id);
    notifyListeners();
  }

  bool isCartFetched = false;
  //TODO: remove productID if not used and convert it to a list
  // TODO: make items private
  /// Key is productId and value is cartItem.

  late final CartController _cartController = CartController(authToken);
  // A list of all products placed in cart.
  List<CartItem> get items {
    return UnmodifiableListView(cartItems);
  }

  /// Number of products placed in cart.
  get cartItemsCount {
    return cartItems.length;
  }

  /// Cart total amount.
  double get total {
    double total = 0.00;
    for (var cartItem in cartItems) {
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
    for (CartItem cartItem in cartItems) {
      if (cartItem.product.id == product.id) {
        return cartItem;
      }
    }
    return null;
  }

  Future<void> getAndSetCart() async {
    List<CartItem>? items = await _cartController.get();
    cartItems = items;
    notifyListeners();
    isCartFetched = true;
  }

  // Increments the quantity of the CartItem if it exists in cart.
  void increment(CartItem cartItem) {
    int index = cartItems.indexOf(cartItem);
    if (index != -1) {
      cartItems[index] = cartItem.copyWith(quantity: cartItem.quantity + 1);
    }
  }

  // Decrements the quantity of the CartItem if it exists in cart.
  void decrement(CartItem cartItem) {
    int index = cartItems.indexOf(cartItem);
    if (index != -1) {
      cartItems[index] = cartItem.copyWith(quantity: cartItem.quantity - 1);
    }
  }

  /// Adds a new product to cart or increases the quantity of an already existing one.
  void add(Product product) async {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].product.id == product.id) {
        await _cartController
            .incrementQuantity(cartItems[i])
            .then((value) => increment(cartItems[i]))
            .catchError(handleError);
        notifyListeners();

        return;
      }
    }
    // create new cartItem with quantity of 1
    CartItem newCartItem =
        CartItem(id: const Uuid().v4(), product: product, quantity: 1);

    await _cartController
        .create(newCartItem)
        .then((_) => cartItems.add(newCartItem))
        .catchError(handleError);
    notifyListeners();
  }

  /// Subtracts one from the quantity of that item or removes the item totally if called while quantity was 1.
  void decrementQuantity(CartItem cartItemInput) async {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].id == cartItemInput.id) {
        if (cartItems[i].quantity == 1) {
          CartItem removedProduct = cartItems[i];
          await _cartController
              .delete(removedProduct)
              .then((_) => cartItems
                  .removeWhere((cartItem) => cartItem.id == cartItemInput.id))
              .catchError(handleError);
          notifyListeners();
        } else {
          await _cartController.decrementQuantity(cartItemInput).then((_) {
            decrement(cartItems[i]);
          }).catchError(handleError);
          notifyListeners();
        }
        break;
      }
    }
    return;
  }

  /// Removes all items from the cart.
  Future<void> clear() async {
    await _cartController.clearCart(cartItems);
    cartItems = [];
    notifyListeners();
  }
}

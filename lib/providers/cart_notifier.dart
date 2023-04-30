import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:store_app/controllers/cart_controller.dart';
import 'package:uuid/uuid.dart';

import '../controllers/excpetion_handler.dart';
import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';

class CartNotifier with ChangeNotifier, ExceptionHandler {
  List<CartItem> cartItems;
  CartNotifier(this.cartItems);
  late final CartController _cartController = CartController();
  bool isCartFetched = false;

  //TODO: remove productID if not used and convert it to a list
  // TODO: make items private
  /// Key is productId and value is cartItem.

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

  /// Checks if cartItem's size and quantity are available.
  ///
  /// This method should be called before ordering because cartItem's product doesn't get updated if a product changes.
  Future<bool> isCartItemWithCurrentSizeAndQuantity(
      CartItem cartItem, List<Product> products) async {
    Product currentProduct =
        products.firstWhere((element) => element.id == cartItem.product.id);
    int currentQuantity = currentProduct.sizeQuantity[cartItem.size] as int;
    if (currentQuantity >= cartItem.quantity) {
      return true;
    } else {
      int index = items.indexOf(cartItem);
      cartItems[index] = cartItem.copyWith(quantity: currentQuantity);
      notifyListeners();
      return false;
    }
  }

  Future<void> getAndSetCart() async {
    List<CartItem>? items = await _cartController.get();
    cartItems = items;
    notifyListeners();
    isCartFetched = true;
  }

  /// Delete an item from the cart using this item's id.
  void deleteItem(CartItem cartItemInput) async {
    await _cartController.delete(cartItemInput.id).then((value) {
      cartItems.removeWhere((cartItem) => cartItemInput.id == cartItem.id);
      notifyListeners();
    }).catchError(handleException);
  }

  void deleteCartItemsByProductId(String productId) async {
    await _cartController.deleteCartItemsByProductId(productId);
    cartItems.removeWhere((cartItem) => productId == cartItem.product.id);
    notifyListeners();
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

  Future<void> setQuantity(Product product, int quantity, String size) async {
    for (int i = 0; i < cartItems.length; i++) {
      // if already exists in cart
      if (cartItems[i].product.id == product.id && size == cartItems[i].size) {
        await _cartController.setQuantity(cartItems[i], quantity).then((value) {
          cartItems[i] = cartItems[i].copyWith(quantity: quantity);
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
        .then((_) => cartItems.add(newCartItem))
        .catchError(handleException);
    notifyListeners();
  }

  /// Adds a new product to cart or increases the quantity of an already existing one.
  void add(Product product, String size) async {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].product.id == product.id && cartItems[i].size == size) {
        await _cartController
            .incrementQuantity(cartItems[i])
            .then((value) => increment(cartItems[i]))
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
        .then((_) => cartItems.add(newCartItem))
        .catchError(handleException);
    notifyListeners();
  }

  /// Subtracts one from the quantity of that item or removes the item totally if called while quantity was 1.
  void decrementQuantity(CartItem cartItemInput) async {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].id == cartItemInput.id) {
        if (cartItems[i].quantity == 1) {
          CartItem removedCartItem = cartItems[i];
          await _cartController
              .delete(removedCartItem.id)
              .then((_) => cartItems
                  .removeWhere((cartItem) => cartItem.id == cartItemInput.id))
              .catchError(handleException);
          notifyListeners();
        } else {
          await _cartController.decrementQuantity(cartItemInput).then((_) {
            decrement(cartItems[i]);
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
    await _cartController.clearCart(cartItems);
    cartItems = [];
    notifyListeners();
  }
}


// TODO:  Here's what I would do. You're having foo1 handle the error and show an error dialog and it's caused you this pain. Instead of doing that, create a function for showing error dialogs. Add a try/catch block wherever execution must stop due to this error. Maybe it's the foo1, foo2 call, maybe it's even higher up in the call stack. (preferably higher up) Create a custom error called DialogableException Catch DialogableException and execute the function that creates the error dialog. DialogableException can be constructed with the error message to display. With this design you can halt for any error and the framework is in place for you to simply create error dialogs for the user by throwing an exception whenever you fail to handle something for the user. By having a custom exception you don't catch asserts or other real errors that may happen. I believe this scales better than the bool, but if you don't need this kind of framework because you don't expect to have to show dialogs for other stuff then a simple bool is okay.
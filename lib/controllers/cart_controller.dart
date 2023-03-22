import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/mixins/add_token_to_url.dart';

import '../models/cart_item/cart_item.dart';

class CartController with AddTokenToUrl {
  CartController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final String kCartCollection = 'cart';
  Future<List<CartItem>> get() async {
    List<CartItem> cartItems = [];
    QuerySnapshot snapshot = await db.collection(kCartCollection).get();
    for (var docSnapshot in snapshot.docs) {
      cartItems
          .add(CartItem.fromJson(docSnapshot.data() as Map<String, dynamic>));
    }
    return cartItems;
  }

  /// Creates a new cart item in cart.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> create(CartItem cartItem) async {
    await httpRequestTemplate(() async {
      await db.collection(kCartCollection).doc(cartItem.id).set(cartItem.toJson());
    });
  }

  /// Increments the quantity of an already existing CartItem using its id.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> incrementQuantity(CartItem cartItem) async {
    await httpRequestTemplate(() async {
      await db.collection(kCartCollection).doc(cartItem.id).set(
          cartItem.copyWith(quantity: cartItem.quantity + 1).toJson(),
          SetOptions(merge: true));
    });
  }

  ///Decrements quantity of cart item by one.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> decrementQuantity(CartItem cartItem) async {
    await httpRequestTemplate(() async {
      await db.collection(kCartCollection).doc(cartItem.id).set(
          cartItem.copyWith(quantity: cartItem.quantity - 1).toJson(),
          SetOptions(merge: true));
    });
  }

  /// Set the quantity of an already existing CartItem.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> setQuantity(CartItem cartItem, int quantity) async {
    await httpRequestTemplate(() async {
      await db.collection(kCartCollection).doc(cartItem.id).set(
          cartItem.copyWith(quantity: quantity).toJson(),
          SetOptions(merge: true));
    });
  }

  /// Throws an exception if operatoin fails.
  Future<void> delete(String cartItemId, {bool showLoading = true}) async {
    await httpRequestTemplate(() async {
      await db.collection(kCartCollection).doc(cartItemId).delete();
    }, showLoading: showLoading);
  }

  Future<void> httpRequestTemplate(Function foo,
      {bool showLoading = true}) async {
    if (showLoading) DialogHelper.showLoading();
    await foo();
    if (showLoading) DialogHelper.hideCurrentDialog();
  }

  Future<void> clearCart(List<CartItem> cartItems) async {
    for (var cartItem in cartItems) {
      await delete(cartItem.id, showLoading: false);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/mixins/add_token_to_url.dart';

import '../models/cart_item/cart_item.dart';

class CartController with AddTokenToUrl {
  CartController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late final DocumentReference _userDoc =
      db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

  Future<List<CartItem>> get() async {
    List<CartItem> cartItems = [];
    var userDoc = await _userDoc.get();
    for (var cartItemDict in userDoc['cartItems']) {
      cartItems.add(CartItem.fromJson(cartItemDict));
    }
    return cartItems;
  }

  /// Creates a new cart item in cart.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> create(CartItem cartItem) async {
    await httpRequestTemplate(() async {
      await _userDoc.update({
        'cartItems': FieldValue.arrayUnion([cartItem.toJson()]),
      });
    });
  }

  /// Increments the quantity of an already existing CartItem using its id.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> incrementQuantity(String cartItemId) async {
    await httpRequestTemplate(() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User is not authenticated");
      }
      final userDocRef =
          FirebaseFirestore.instance.collection("users").doc(currentUser.uid);
      final userDocSnapshot = await userDocRef.get();
      if (!userDocSnapshot.exists) {
        throw Exception("User document does not exist");
      }
      final cartItemsDicts =
          List<Map<String, dynamic>>.from(userDocSnapshot.get("cartItems"));
      List<CartItem> cartItems =
          cartItemsDicts.map((e) => CartItem.fromJson(e)).toList();
      CartItem newCartItem =
          cartItems.firstWhere((element) => element.id == cartItemId);
      newCartItem = newCartItem.copyWith(quantity: newCartItem.quantity + 1);
      cartItems.removeWhere((element) => element.id == newCartItem.id);
      cartItems.add(newCartItem);
      await userDocRef.update({"cartItems": cartItems.map((e) => e.toJson())});
    });
  }

  ///Decrements quantity of cart item by one.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> decrementQuantity(CartItem cartItem) async {
    await httpRequestTemplate(() async {
      await _userDoc.set(
          cartItem.copyWith(quantity: cartItem.quantity - 1).toJson(),
          SetOptions(merge: true));
    });
  }

  /// Set the quantity of an already existing CartItem.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> setQuantity(CartItem cartItem, int quantity) async {
    await httpRequestTemplate(() async {
      await _userDoc.set(cartItem.copyWith(quantity: quantity).toJson(),
          SetOptions(merge: true));
    });
  }

  /// Throws an exception if operatoin fails.
  Future<void> delete(String cartItemId, {bool showLoading = true}) async {
    await httpRequestTemplate(() async {
      await _userDoc.update({
        'cartItems': FieldValue.arrayRemove([
          {'id': cartItemId}
        ])
      });
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

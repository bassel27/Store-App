import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/helper/dialog_helper.dart';


import '../models/cart_item/cart_item.dart';

class CartController  {
  CartController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  get _userDoc {
    return db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
  }

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
      await _userDoc.set({
        'cartItems': FieldValue.arrayUnion([cartItem.toJson()]),
      }, SetOptions(merge: true));
    });
  }

  /// Increments the quantity of an already existing CartItem using its id.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> incrementQuantity(CartItem cartItem) async {
    await setQuantity(cartItem.id, cartItem.quantity + 1);
  }

  ///Decrements quantity of cart item by one.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> decrementQuantity(CartItem cartItem) async {
    await setQuantity(cartItem.id, cartItem.quantity - 1);
  }

  /// Set the quantity of an already existing CartItem.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> setQuantity(String cartItemId, int quantity) async {
    await httpRequestTemplate(() async {
      final userDocSnapshot = await _userDoc.get();
      final cartItemsDicts =
          List<Map<String, dynamic>>.from(userDocSnapshot.get("cartItems"));
      List<CartItem> cartItems =
          cartItemsDicts.map((e) => CartItem.fromJson(e)).toList();
      CartItem newCartItem =
          cartItems.firstWhere((element) => element.id == cartItemId);
      newCartItem = newCartItem.copyWith(quantity: quantity);
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i].id == newCartItem.id) {
          cartItems[i] = newCartItem;
          break;
        }
      }
      await _userDoc.set({"cartItems": cartItems.map((e) => e.toJson())},
          SetOptions(merge: true));
    });
  }

  /// Throws an exception if operatoin fails.
  Future<void> delete(CartItem cartItem, {bool showLoading = true}) async {
    await httpRequestTemplate(() async {
      await _userDoc.update({
        'cartItems': FieldValue.arrayRemove([cartItem.toJson()])
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
      await delete(cartItem, showLoading: false);
    }
  }
}

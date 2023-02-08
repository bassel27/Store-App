import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/models/constants.dart';

import '../models/cart_item/cart_item.dart';
import '../services/base_client.dart';

class CartController with ErrorHandler {
  Future<List<CartItem>> get() async {
    Map<String, dynamic>? cartItemMaps =
        await BaseClient.get(kCartUrl); // map of cartItem maps.
    List<CartItem> cartItems = [];
    if (cartItemMaps != null) {
      // if cart not empty
      cartItemMaps.forEach((cartItemId, cartItemData) {
        cartItems.add(CartItem.fromJson(cartItemData));
      });
    }
    return cartItems;
  }

  /// Creates a new cart item in cart.
  ///
  /// Returns true if operation was successful.
  Future<bool> create(CartItem cartItem) async {
    return await httpRequestTemplate(() async {
      await BaseClient.put(
        _cartUrlWithId(cartItem.id),
        cartItem.toJson(),
      );
    });
  }

  /// Increments the quantity of an already existing CartItem using its id.
  ///
  /// Returns true if operation was successful.
  Future<bool> incrementQuantity(CartItem cartItem) async {
    return await httpRequestTemplate(() async {
      await BaseClient.patch(
        _cartUrlWithId(cartItem.id),
        cartItem.copyWith(quantity: cartItem.quantity + 1).toJson(),
      );
    });
  }

  ///Decrements quantity of cart item by one.
  ///
  /// Returns true if operation was successful.
  Future<bool> decrementQuantity(CartItem cartItem) async {
    return await httpRequestTemplate(() async {
      await BaseClient.patch(
        _cartUrlWithId(
          cartItem.id,
        ),
        cartItem.copyWith(quantity: cartItem.quantity - 1).toJson(),
      );
    });
  }

  /// Returns true if operation was successful.
  Future<bool> delete(CartItem cartItem, {bool showLoading = true}) async {
    return await httpRequestTemplate(() async {
      await BaseClient.delete(
        "$kCartBaseUrl/${cartItem.id}.json",
      );
    }, showLoading: showLoading);
  }

  String _cartUrlWithId(String id) {
    return "$kCartBaseUrl/$id.json";
  }

  Future<bool> httpRequestTemplate(Function foo,
      {bool showLoading = true}) async {
    if (showLoading) DialogHelper.showLoading();
    try {
      await foo();
    } catch (e) {
      handleError(e);
      return false;
    }
    if (showLoading) DialogHelper.hideCurrentDialog();
    return true;
  }

  Future<void> clearCart(List<CartItem> cartItems) async {
    for (var cartItem in cartItems) {
      await delete(cartItem, showLoading: false);
    }
  }
}

import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/models/constants.dart';

import '../models/cart_item/cart_item.dart';
import '../services/base_client.dart';

class CartController {
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
  /// Throws an exception if operatoin fails.
  Future<void> create(CartItem cartItem) async {
    await httpRequestTemplate(() async {
      await BaseClient.put(
        _cartUrlWithId(cartItem.id),
        cartItem.toJson(),
      );
    });
  }

  /// Increments the quantity of an already existing CartItem using its id.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> incrementQuantity(CartItem cartItem) async {
    await httpRequestTemplate(() async {
      await BaseClient.patch(
        _cartUrlWithId(cartItem.id),
        cartItem.copyWith(quantity: cartItem.quantity + 1).toJson(),
      );
    });
  }

  ///Decrements quantity of cart item by one.
  ///
  /// Throws an exception if operatoin fails.
  Future<void> decrementQuantity(CartItem cartItem) async {
    await httpRequestTemplate(() async {
      await BaseClient.patch(
        _cartUrlWithId(
          cartItem.id,
        ),
        cartItem.copyWith(quantity: cartItem.quantity - 1).toJson(),
      );
    });
  }

  /// Throws an exception if operatoin fails.
  Future<void> delete(CartItem cartItem, {bool showLoading = true}) async {
    await httpRequestTemplate(() async {
      await BaseClient.delete(
        "$kCartBaseUrl/${cartItem.id}.json",
      );
    }, showLoading: showLoading);
  }

  String _cartUrlWithId(String id) {
    return "$kCartBaseUrl/$id.json";
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

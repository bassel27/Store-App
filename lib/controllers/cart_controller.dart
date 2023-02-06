import 'package:store_app/controllers/base_controller.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/models/cart_item.dart';
import 'package:store_app/models/constants.dart';

import '../services/base_client.dart';

class CartController with BaseController {
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
  Future<void> create(CartItem cartItem) async {
    DialogHelper.showLoading();
    try {
      await BaseClient.put(
        _cartUrlWithId(cartItem.id),
        cartItem.toJson(),
      );
    } catch (e) {
      handleError(e);
      return;
    }
    DialogHelper.hideCurrentDialog();
  }

  /// Increments the quantity of an already existing CartItem using its id.
  Future<void> incrementQuantity(CartItem cartItem) async {
    DialogHelper.showLoading();
    try {
      await BaseClient.patch(
        _cartUrlWithId(cartItem.id),
        cartItem.copyWith(quantity: cartItem.quantity + 1).toJson(),
      );
    } catch (e) {
      handleError(e);
      rethrow;
    }
    DialogHelper.hideCurrentDialog();
  }

  Future<void> decrementQuantity(CartItem cartItem) async {
    await BaseClient.patch(
      _cartUrlWithId(
        cartItem.id,
      ),
      cartItem.copyWith(quantity: cartItem.quantity - 1).toJson(),
    );
  }

  Future<void> delete(CartItem cartItem) async {
    await BaseClient.delete(
      "$kCartBaseUrl/${cartItem.id}.json",
    s);
  }

  String _cartUrlWithId(String id) {
    return "$kCartBaseUrl/$id.json";
  }
}

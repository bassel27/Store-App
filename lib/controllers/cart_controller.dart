import 'package:store_app/models/cart_item.dart';
import 'package:store_app/models/constants.dart';

import '../services/base_client.dart';

const int CHANGE_QUANTITY_TIMEOUT = 1;

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
  Future<void> create(CartItem cartItem) async {
    await BaseClient.put(_cartUrlWithId(cartItem.id), cartItem.toJson(),
        timeOutDuration: CHANGE_QUANTITY_TIMEOUT);
  }

  /// Increments the quantity of an already existing CartItem using its id.
  Future<void> incrementQuantity(CartItem cartItem) async {
    await BaseClient.patch(_cartUrlWithId(cartItem.id),
        cartItem.copyWith(quantity: cartItem.quantity + 1).toJson(),
        timeOutDuration: CHANGE_QUANTITY_TIMEOUT);
  }

  Future<void> decrementQuantity(CartItem cartItem) async {
    await BaseClient.patch(
        _cartUrlWithId(
          cartItem.id,
        ),
        cartItem.copyWith(quantity: cartItem.quantity - 1).toJson(),
        timeOutDuration: CHANGE_QUANTITY_TIMEOUT);
  }

  Future<void> delete(CartItem cartItem) async {
    await BaseClient.delete("$kCartBaseUrl/${cartItem.id}.json",
        timeoutDuration: CHANGE_QUANTITY_TIMEOUT);
  }

  String _cartUrlWithId(String id) {
    return "$kCartBaseUrl/$id.json";
  }
}

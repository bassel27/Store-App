import 'package:store_app/models/cart_item.dart';
import 'package:store_app/models/constants.dart';

import '../services/base_client.dart';

class CartController {
  Future<List<CartItem>> get() async {
    Map<String, dynamic> cartItemMaps =
        await BaseClient.get(kCartUrl); // map of cartItem maps.
    List<CartItem> cartItems = [];
    cartItemMaps.forEach((cartItemId, cartItemData) {
      cartItems.add(CartItem.fromJson(cartItemData));
    });
    return cartItems;
  }

  Future<void> create(CartItem cartItem) async {
    var response = await BaseClient.put(
        cartUrlWithId(cartItem.id), {'cartItem': cartItem.toJson()});
  }

  String cartUrlWithId(String id) {
    return "$kCartBaseUrl/$id.json";
  }
}

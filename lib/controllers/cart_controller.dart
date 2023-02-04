import 'package:store_app/models/cart_item.dart';
import 'package:store_app/models/constants.dart';

import '../services/base_client.dart';

class CartController {
  // Future<List<CartItem>> get() async {
  //   await BaseClient.get(kCartUrl);
  // }

  Future<void> create(List<CartItem> cartItems) async {
    await BaseClient.post(kCartUrl, {
      'cartItem': cartItems
          .map((cartItem) => {
                'product': cartItem.product,
                'quantity': cartItem.quantity,
              })
          .toList()
    });
  }
}

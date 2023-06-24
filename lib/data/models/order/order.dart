import 'package:freezed_annotation/freezed_annotation.dart';

import '../address/address.dart';
import '../cart_item/cart_item.dart';
import 'package:decimal/decimal.dart';
part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const Order._();
  const factory Order(
      {required String id,
      required Decimal total,
      required List<CartItem> cartItems,
      required String userId,
      required Address address,
      @Default(false)  bool isDone,
      required DateTime dateTime}) = _Order;
  int get numberOfProducts {
    return cartItems.length;
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

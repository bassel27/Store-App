import 'package:freezed_annotation/freezed_annotation.dart';

import '../cart_item/cart_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const Order._();
  const factory Order(
      {required String id,
      required double total,
      required List<CartItem> cartItems,
      required String userId,
      required DateTime dateTime}) = _Order;
  int get numberOfProducts {
    return cartItems.length;
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

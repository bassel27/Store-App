// import 'package:store_app/models/cart_item.dart';

// class Order {
//   final String _id;
//   /// Total amount paid.
//   final double _amount;
//   final List<CartItem> _products;

//   /// Time the order was placed.
//   final DateTime _dateTime;

//   Order(
//       {required String id,
//       required double total,
//       required List<CartItem> products,
//       required DateTime dateTime})
//       : _id = id,
//         _amount = total,
//         _products = products,
//         _dateTime = dateTime;

//   get id => _id;
//   get amount => _amount;
//   List<CartItem> get products => _products;
//   get dateTime => _dateTime;

//   int get numberOfProducts => _products.length;
// }

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const Order._();
  const factory Order(
      {required String id,
      required double total,
      required List<CartItem> cartItems,
      required DateTime dateTime}) = _Order;
  int get numberOfProducts {
    return cartItems.length;
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

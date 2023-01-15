import 'package:store_app/models/cart_item.dart';

class OrderItem {
  final String _id;
  final double _amount;
  final List<CartItem> _products;

  /// Time the order was placed.
  final DateTime _dateTime;

  OrderItem(
      {required String id,
      required double amount,
      required List<CartItem> products,
      required DateTime dateTime})
      : _id = id,
        _amount = amount,
        _products = products,
        _dateTime = dateTime;

  get id => _id;
  get amount => _amount;
  get products => _products;
  get dateTime => _dateTime;
}

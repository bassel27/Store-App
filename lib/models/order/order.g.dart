// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Order _$$_OrderFromJson(Map<String, dynamic> json) => _$_Order(
      id: json['id'] as String,
      total: Decimal.fromJson(json['total'] as String),
      cartItems: (json['cartItems'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: json['userId'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$$_OrderToJson(_$_Order instance) => <String, dynamic>{
      'id': instance.id,
      'total': instance.total.toJson(),
      'cartItems':
          instance.cartItems.map((cartItem) => cartItem.toJson()).toList(),
      'userId': instance.userId,
      'dateTime': instance.dateTime.toIso8601String(),
    };

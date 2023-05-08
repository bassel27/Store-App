// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Product _$$_ProductFromJson(Map<String, dynamic> json) => _$_Product(
      title: json['title'] as String,
      description: json['description'] as String?,
      id: json['id'] as String,
      price: Decimal.fromJson(json['price'] as String),
      imageUrl: json['imageUrl'] as String?,
      sizeQuantity: (json['sizeQuantity'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
    );

Map<String, dynamic> _$$_ProductToJson(_$_Product instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'id': instance.id,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'sizeQuantity': instance.sizeQuantity,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Product _$$_ProductFromJson(Map<String, dynamic> json) => _$_Product(
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      id: json['id'] as String,
      price: (json['price'] as num).toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$_ProductToJson(_$_Product instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'description': instance.description,
      'id': instance.id,
      'price': instance.price,
      'isFavorite': instance.isFavorite,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      id: json['id'] as String,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      isAdmin: json['isAdmin'] as bool? ?? false,
      // favoriteProducts: (json['favoriteProducts'] as List<dynamic>?)
      //         ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      //         .toList() ??
      //     const [],
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'id': instance.id,
      'address': instance.address,
      'isAdmin': instance.isAdmin,
      'favoriteProducts': instance.favoriteProducts,
    };

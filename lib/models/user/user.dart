import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../cart_item/cart_item.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User{
  const factory User({
    required String email,
    required String firstName,
    required String lastName,
    required String id,
    @Default(false) bool isAdmin,
    @JsonKey(ignore: true) String? password,
    @Default([]) List<CartItem> favoriteProducts,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

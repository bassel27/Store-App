import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';
// TODO: remove password
@freezed
class User with _$User {
  const factory User({
    required String email,
    required String firstName,
    required String lastName,
    required String id,
    required String password,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  String? get password => throw _privateConstructorUsedError;
  List<CartItem> get favoriteProducts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String email,
      String firstName,
      String lastName,
      String id,
      @JsonKey(ignore: true) String? password,
      List<CartItem> favoriteProducts});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? id = null,
    Object? password = freezed,
    Object? favoriteProducts = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      favoriteProducts: null == favoriteProducts
          ? _value.favoriteProducts
          : favoriteProducts // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String firstName,
      String lastName,
      String id,
      @JsonKey(ignore: true) String? password,
      List<CartItem> favoriteProducts});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? id = null,
    Object? password = freezed,
    Object? favoriteProducts = null,
  }) {
    return _then(_$_User(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      favoriteProducts: null == favoriteProducts
          ? _value._favoriteProducts
          : favoriteProducts // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_User implements _User {
  const _$_User(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.id,
      @JsonKey(ignore: true) this.password,
      final List<CartItem> favoriteProducts = const []})
      : _favoriteProducts = favoriteProducts;

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String id;
  @override
  @JsonKey(ignore: true)
  final String? password;
  final List<CartItem> _favoriteProducts;
  @override
  @JsonKey()
  List<CartItem> get favoriteProducts {
    if (_favoriteProducts is EqualUnmodifiableListView)
      return _favoriteProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteProducts);
  }

  @override
  String toString() {
    return 'User(email: $email, firstName: $firstName, lastName: $lastName, id: $id, password: $password, favoriteProducts: $favoriteProducts)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.password, password) ||
                other.password == password) &&
            const DeepCollectionEquality()
                .equals(other._favoriteProducts, _favoriteProducts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, firstName, lastName, id,
      password, const DeepCollectionEquality().hash(_favoriteProducts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String email,
      required final String firstName,
      required final String lastName,
      required final String id,
      @JsonKey(ignore: true) final String? password,
      final List<CartItem> favoriteProducts}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get email;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  String? get password;
  @override
  List<CartItem> get favoriteProducts;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}

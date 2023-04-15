// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get title => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // TODO: remove required
  String get id => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  bool get isFavorite => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  Map<String, int> get sizeQuantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String title,
      String? description,
      String id,
      double price,
      @JsonKey(ignore: true) bool isFavorite,
      String? imageUrl,
      Map<String, int> sizeQuantity});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? id = null,
    Object? price = null,
    Object? isFavorite = null,
    Object? imageUrl = freezed,
    Object? sizeQuantity = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sizeQuantity: null == sizeQuantity
          ? _value.sizeQuantity
          : sizeQuantity // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$_ProductCopyWith(
          _$_Product value, $Res Function(_$_Product) then) =
      __$$_ProductCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? description,
      String id,
      double price,
      @JsonKey(ignore: true) bool isFavorite,
      String? imageUrl,
      Map<String, int> sizeQuantity});
}

/// @nodoc
class __$$_ProductCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$_Product>
    implements _$$_ProductCopyWith<$Res> {
  __$$_ProductCopyWithImpl(_$_Product _value, $Res Function(_$_Product) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? id = null,
    Object? price = null,
    Object? isFavorite = null,
    Object? imageUrl = freezed,
    Object? sizeQuantity = null,
  }) {
    return _then(_$_Product(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sizeQuantity: null == sizeQuantity
          ? _value._sizeQuantity
          : sizeQuantity // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Product implements _Product {
  const _$_Product(
      {required this.title,
      required this.description,
      required this.id,
      required this.price,
      @JsonKey(ignore: true) this.isFavorite = false,
      this.imageUrl,
      final Map<String, int> sizeQuantity = const {}})
      : _sizeQuantity = sizeQuantity;

  factory _$_Product.fromJson(Map<String, dynamic> json) =>
      _$$_ProductFromJson(json);

  @override
  final String title;
  @override
  final String? description;
// TODO: remove required
  @override
  final String id;
  @override
  final double price;
  @override
  @JsonKey(ignore: true)
  final bool isFavorite;
  @override
  final String? imageUrl;
  final Map<String, int> _sizeQuantity;
  @override
  @JsonKey()
  Map<String, int> get sizeQuantity {
    if (_sizeQuantity is EqualUnmodifiableMapView) return _sizeQuantity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sizeQuantity);
  }

  @override
  String toString() {
    return 'Product(title: $title, description: $description, id: $id, price: $price, isFavorite: $isFavorite, imageUrl: $imageUrl, sizeQuantity: $sizeQuantity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Product &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._sizeQuantity, _sizeQuantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, description, id, price,
      isFavorite, imageUrl, const DeepCollectionEquality().hash(_sizeQuantity));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProductCopyWith<_$_Product> get copyWith =>
      __$$_ProductCopyWithImpl<_$_Product>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProductToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  const factory _Product(
      {required final String title,
      required final String? description,
      required final String id,
      required final double price,
      @JsonKey(ignore: true) final bool isFavorite,
      final String? imageUrl,
      final Map<String, int> sizeQuantity}) = _$_Product;

  factory _Product.fromJson(Map<String, dynamic> json) = _$_Product.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override // TODO: remove required
  String get id;
  @override
  double get price;
  @override
  @JsonKey(ignore: true)
  bool get isFavorite;
  @override
  String? get imageUrl;
  @override
  Map<String, int> get sizeQuantity;
  @override
  @JsonKey(ignore: true)
  _$$_ProductCopyWith<_$_Product> get copyWith =>
      throw _privateConstructorUsedError;
}

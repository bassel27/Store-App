import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String title,
    required String? description, // TODO: remove required
    required String id,
    required double price,
    @Default(false) @JsonKey(ignore: true) bool isFavorite,
    String? imageUrl,
    @Default({})
        Map<String, int>
            sizeQuantity, // new property to store size and quantity data
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  static int sizeComparator(String size1, String size2) {
    // Define the order of sizes for clothes
    List<String> clothesOrder = ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL'];
    // Check if the sizes are for clothes or shoes
    bool isClothes =
        clothesOrder.contains(size1) && clothesOrder.contains(size2);
    bool isShoes = true;
    if (int.tryParse(size1) == null && int.tryParse(size1) == null) {
      isShoes = false;
    }

    if (!isClothes && !isShoes) {
      // Sizes are not comparable
      return 0;
    } else if (isClothes) {
      // Compare sizes for clothes
      return clothesOrder.indexOf(size1) - clothesOrder.indexOf(size2);
    } else {
      // Compare sizes for shoes
      return int.parse(size1) - int.parse(size2);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          this.id == other.id;
}

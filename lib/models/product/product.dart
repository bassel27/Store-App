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

    // Define the order of sizes for shoes
    List<int> shoeOrder = List.generate(100, (index) => index + 1);

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

  Map<String, int> get sizeQunatity {
    List<MapEntry<String, int>> entries = sizeQuantity.entries.toList();
    entries.sort((a, b) => sizeComparator(a.key, b.key));
    return Map.fromEntries(entries);
  }
}

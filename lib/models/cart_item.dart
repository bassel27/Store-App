import 'package:store_app/models/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final String? id; // if CartItem of fetched order then id doesn't matter. // id matters only for cartItems that are currently in cart
  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> cartItemMap) {
    return CartItem(
      quantity: cartItemMap['quantity'],
      id: null,
      product: Product(
        title: cartItemMap['product']['title'],
        description: cartItemMap['product']['description'],
        id: cartItemMap['product']['id'],
        imageUrl: cartItemMap['product']['imageUrl'],
        price: cartItemMap['product']['price'],
        isFavorite: cartItemMap['product']['isFavorite'],
      ),
    );
  }

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
  }) {
    return CartItem(
        id: id ?? this.id,
        product: product ?? this.product,
        quantity: quantity ?? this.quantity);
  }
}

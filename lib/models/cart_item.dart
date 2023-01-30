class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});

  factory CartItem.fromJson(Map<String, dynamic> productMap) {
    return CartItem(
        quantity: productMap['quantity'],
        id: productMap['id'],
        title: productMap['title'],
        price: productMap['price']);
  }
}

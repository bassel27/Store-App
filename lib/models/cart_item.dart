class CartItem {
  final String id;
  final String name;
  int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.price});
}

class CartItem {
  final String _id;
  final String _name;
  final int _quantity;
  final double _price;

  CartItem(
      {required String id,
      required String name,
      required int quantity,
      required double price})
      : _id = id,
        _name = name,
        _quantity = quantity,
        _price = price;
  get id {
    return _id;
  }

  get name {
    return _name;
  }

  get quantity {
    return _quantity;
  }

  get price {
    return _price;
  }
}

// the ChnageNotifier is a mixin.
//Using a mixin is like extending another class.
//The difference is that you merge some properties and methods from that class
// to use in your class, but your class doesn't become an instance of that class.
import 'package:provider/provider.dart';
import 'package:store_app/providers/productNotifier.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  final List<ProductNotifier> _productsList = [
    ProductNotifier(
      id: 'p1',
      title: 'Zyrtec',
      description: 'Cetirizine hydrochloride',
      price: 29.99,
      imageUrl: 'https://seif-online.com/wp-content/uploads/2020/01/57612-.jpg',
    ),
    ProductNotifier(
      id: 'p2',
      title: 'Panadol',
      description: 'Painkiller',
      price: 59.99,
      imageUrl:
          'https://cdn.altibbi.com/cdn/cache/1000x500/image/2021/05/30/18178cb23d988afad24a24b16d914b3b.webp',
    ),
    ProductNotifier(
      id: 'p3',
      title: 'Fucidin',
      description: 'Antibiotic',
      price: 19.99,
      imageUrl:
          'https://seif-online.com/wp-content/uploads/2020/01/180614-.jpg',
    ),
    ProductNotifier(
      id: 'p4',
      title: 'Augemntin',
      description: 'Antibiotic',
      price: 49.99,
      imageUrl: 'https://seif-online.com/wp-content/uploads/2020/01/40413-.jpg',
    ),
  ];

  List<ProductNotifier> get products {
    return [..._productsList];
  }

  List<ProductNotifier> get favoriteProducts {
    return [..._productsList].where((product) => product.isFavorite).toList();
  }

  // Returns a copy so that the only way to add a
  // product is through our method which calls notifyListeners().
  // If you added to the returned original list, notifyListeners won't be called.

  void addProduct(ProductNotifier newProduct) {
    _productsList.add(newProduct);
    notifyListeners();
  }
}

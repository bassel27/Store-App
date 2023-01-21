// the ChnageNotifier is a mixin.
//Using a mixin is like extending another class.
//The difference is that you merge some properties and methods from that class
// to use in your class, but your class doesn't become an instance of that class.
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsNotifier with ChangeNotifier {
  Product _editedProduct =
      Product(id: '', name: '', description: '', price: 0, imageUrl: '');

  Product get editedProduct {
    return _editedProduct;
  }

  set editedProductId(String id) {
    _editedProduct = Product(
        id: id,
        name: _editedProduct.name,
        description: _editedProduct.description,
        price: _editedProduct.price,
        imageUrl: _editedProduct.imageUrl);
  }

  set editedProductName(String name) {
    _editedProduct = Product(
        id: _editedProduct.id,
        name: name,
        description: _editedProduct.description,
        price: _editedProduct.price,
        imageUrl: _editedProduct.imageUrl);
  }

  set editedProductPrice(double price) {
    _editedProduct = Product(
        id: _editedProduct.id,
        name: _editedProduct.name,
        description: _editedProduct.description,
        price: price,
        imageUrl: _editedProduct.imageUrl);
  }

  set editedProductDescription(String? description) {
    if (description != null) {
      _editedProduct = Product(
          id: _editedProduct.id,
          name: _editedProduct.name,
          description: description,
          price: _editedProduct.price,
          imageUrl: _editedProduct.imageUrl);
    }
  }

  set editedProductImageUrl(String imageUrl) {
    _editedProduct = Product(
        id: _editedProduct.id,
        name: _editedProduct.name,
        description: _editedProduct.description,
        price: _editedProduct.price,
        imageUrl: imageUrl);
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProducts {
    return [..._products].where((product) => product.isFavorite).toList();
  }

  // Returns a copy so that the only way to add a
  // product is through our method which calls notifyListeners().
  // If you added to the returned original list, notifyListeners won't be called.

  void addProduct(Product newProduct) {
    newProduct = Product(
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
        name: newProduct.name,
        id: DateTime.now().toString());
    _products.add(newProduct);
    notifyListeners();
  }

  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Zyrtec',
      description: 'Cetirizine hydrochloride',
      price: 29.99,
      imageUrl: 'https://seif-online.com/wp-content/uploads/2020/01/57612-.jpg',
    ),
    Product(
      id: 'p2',
      name: 'Panadol',
      description: 'Painkiller',
      price: 59.99,
      imageUrl:
          'https://i-cf65.ch-static.com/content/dam/cf-consumer-healthcare/panadol/en_eg/Home/1680%20x%20600.jpg?auto=format',
    ),
    Product(
      id: 'p3',
      name: 'Fucidin',
      description: 'Antibiotic',
      price: 19.99,
      imageUrl:
          'https://seif-online.com/wp-content/uploads/2020/01/180614-.jpg',
    ),
    Product(
      id: 'p4',
      name: 'Augemntin',
      description: 'Antibiotic',
      price: 49.99,
      imageUrl: 'https://seif-online.com/wp-content/uploads/2020/01/40413-.jpg',
    ),
  ];
}

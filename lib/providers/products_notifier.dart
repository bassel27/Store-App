// the ChnageNotifier is a mixin.
//Using a mixin is like extending another class.
//The difference is that you merge some properties and methods from that class
// to use in your class, but your class doesn't become an instance of that class.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductsNotifier with ChangeNotifier {
  Product editedProduct =
      Product(id: '', name: '', description: '', price: 0, imageUrl: '');

  /// Called when you're done with editing or adding a new product to make editedProduct ready for another use.
  void resetEditedProduct() {
    editedProduct =
        Product(id: '', name: '', description: '', price: 0, imageUrl: '');
    notifyListeners();
  }

  List<Product> get products {
    return [..._products];
  }

  // Returns a copy so that the only way to add a
  // product is through our method which calls notifyListeners().
  // If you added to the returned original list, notifyListeners won't be called.
  List<Product> get favoriteProducts {
    return [..._products].where((product) => product.isFavorite).toList();
  }

  /// Adds the new product to the end of the list of products.
  Future<void> addProduct(Product newProduct) {
    return addProductByIndex(newProduct, _products.length - 1);
  }

  /// Inserts the new product at a specific index in the list of products.
  Future<void> addProductByIndex(Product newProduct, int index) {
    final url = Uri.parse(
        'https://shop-app-f7639-default-rtdb.firebaseio.com/products.json'); //create a products folder or add to it if it already exists
    return http
        .post(url,
            body: json.encode({
              "title": newProduct.name,
              "description": newProduct.description,
              "imageUrl": newProduct.imageUrl,
              "price": newProduct.price,
              "isFavorite": newProduct.isFavorite,
            }))
        .then((response) {
      newProduct = Product(
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl,
          name: newProduct.name,
          id: json.decode(response.body)["name"]);
      _products.insert(index, newProduct);

      notifyListeners();
    });
  }

  updateProduct(String id, Product newProduct) {
    final index = _products.indexWhere((element) => element.id == id);
    if (index >= 0) {
      _products[index] = newProduct;
      notifyListeners();
    }
  }

  /// Deletes a product from the products list by id and returns its index.
  int deleteProduct(String productId) {
    int index = -1;
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == productId) {
        index = i;
        _products.removeAt(index);
      }
    }

    notifyListeners();
    return index;
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

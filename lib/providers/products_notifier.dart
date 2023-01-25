// the ChnageNotifier is a mixin.
//Using a mixin is like extending another class.
//The difference is that you merge some properties and methods from that class
// to use in your class, but your class doesn't become an instance of that class.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductsNotifier with ChangeNotifier {
  void toggleFavoriteStatus(product) {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

  final basicUrl = 'https://shop-app-f7639-default-rtdb.firebaseio.com';
  final productsUrl = Uri.parse(
      'https://shop-app-f7639-default-rtdb.firebaseio.com/products.json'); //create a products folder or add to it if it already exists
  Product editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  /// Called when you're done with editing or adding a new product to make editedProduct ready for another use.
  void resetEditedProduct() {
    editedProduct =
        Product(id: '', title: '', description: '', price: 0, imageUrl: '');
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

  // TODO: handle error
  Future<void> fetchAndSetProducts() async {
    try {
      var response = await http.get(productsUrl);
      Map<String, dynamic> extracedData = json.decode(response.body);
      final List<Product> loadedProducts = [];
      extracedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          description: prodData['description'],
          price: prodData['price'],
          title: prodData['title'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _products = loadedProducts;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  /// Adds the new product to the end of the list of products.
  Future<void> addProduct(Product newProduct) {
    // TODO: handle error
    return addProductByIndex(newProduct, _products.length);
  }

  /// Inserts the new product at a specific index in the list of products.
  Future<void> addProductByIndex(Product newProduct, int index) async {
    // TODO: handle error
    // async returns a future automatically
    final response = await http.post(productsUrl,
        body: json.encode({
          "title": newProduct.title,
          "description": newProduct.description,
          "imageUrl": newProduct.imageUrl,
          "price": newProduct.price,
          "isFavorite": newProduct.isFavorite,
        }));

    newProduct = Product(
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
        title: newProduct.title,
        id: json.decode(response.body)["name"]);
    _products.insert(index, newProduct);
    notifyListeners();
  }

  // TODO: handle error
  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _products.indexWhere((element) => element.id == id);
    if (index >= 0) {
      var oldProductUrl = Uri.parse("$basicUrl/products/$id.json");
      await http.patch(oldProductUrl,
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price,
          }));
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

  List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Zyrtec',
      description: 'Cetirizine hydrochloride',
      price: 29.99,
      imageUrl: 'https://seif-online.com/wp-content/uploads/2020/01/57612-.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Panadol',
      description: 'Painkiller',
      price: 59.99,
      imageUrl:
          'https://i-cf65.ch-static.com/content/dam/cf-consumer-healthcare/panadol/en_eg/Home/1680%20x%20600.jpg?auto=format',
    ),
    Product(
      id: 'p3',
      title: 'Fucidin',
      description: 'Antibiotic',
      price: 19.99,
      imageUrl:
          'https://seif-online.com/wp-content/uploads/2020/01/180614-.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Augemntin',
      description: 'Antibiotic',
      price: 49.99,
      imageUrl: 'https://seif-online.com/wp-content/uploads/2020/01/40413-.jpg',
    ),
  ];
}

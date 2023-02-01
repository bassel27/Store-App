// the ChnageNotifier is a mixin.
//Using a mixin is like extending another class.
//The difference is that you merge some properties and methods from that class
// to use in your class, but your class doesn't become an instance of that class.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/controllers/products_controller.dart';
import 'package:store_app/models/http_exception.dart';

import '../models/constants.dart';
import '../models/product.dart';

class ProductsNotifier with ChangeNotifier {
  /// Used to finalize and be added to products list or cancel making it.
  ///
  /// Either way, you have to reset it afterwards.
  Product editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  ProductsController _productsController = ProductsController();

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

  Future<void> toggleFavoriteStatus(product) async {
    var productUrl = Uri.parse("$kBaseUrl/products/${product.id}.json");
    bool oldStatus = product.isFavorite;
    product.isFavorite = !product.isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(
          productUrl, // delete, patch and put don't throw their own errors
          body: json.encode({
            "isFavorite": product.isFavorite,
          }));
      if (response.statusCode >= 400) {
        product.isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      product.isFavorite = oldStatus;
      notifyListeners();
    }
  }

  // TODO: handle error
  Future<void> fetchAndSetProducts() async {
    List<Product> fetchedProducts = await _productsController.fetchProducts();
    //TODO: this should be removed // if no products in database, create hard coded products just to get going
    if (fetchedProducts == null) {
      for (var element in _hardCodedProducts) {
        addProduct(element);
      }
      return;
    }

    try {
      var response = await http.get(kProductsUri);
      Map<String, dynamic>? extracedData = json.decode(response.body);
      final List<Product> loadedProducts = [];
      //TODO: this should be removed // if no products in database, create hard coded products just to get going
      if (extracedData == null) {
        for (var element in _hardCodedProducts) {
          addProduct(element);
        }
        return;
      }
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
      print("fetchandset products error:$e");
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
    final response = await http.post(kProductsUri,
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
      var oldProductUrl = Uri.parse("$kBaseUrl/products/$id.json");
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
  Future<int> deleteProduct(String productId) async {
    final deletedProductUrl = Uri.parse("$kBaseUrl/products/$productId.json");
    Product? existingProduct;
    int index = -1;
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == productId) {
        index = i;
        existingProduct = products[i];
        _products.removeAt(index);
        notifyListeners();
        final response = await http.delete(deletedProductUrl);
        if (response.statusCode >= 400) {
          _products.insert(index, existingProduct);
          notifyListeners();
          throw (HttpException("Could not delete product"));
        }
      }
    }
    existingProduct = null; // to be garabge collected
    return index;
  }

  List<Product> _products = [];
  final List<Product> _hardCodedProducts = [
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

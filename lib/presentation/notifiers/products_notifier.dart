import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:store_app/data/repositories/product_controller.dart';

import '../../data/models/app_exception.dart';
import '../../data/models/product/product.dart';
import '../../domain/usecases/excpetion_handler.dart';

class ProductsNotifier with ChangeNotifier, ExceptionHandler {
  bool areProductsFetched = false;
  List<Product> _items = [];
  ProductsNotifier();
  late final ProductController _productsController = ProductController();
  Product editedProduct =  Product(
      id: '', title: '', description: '', price: Decimal.parse('0'), imageUrl: null);

  /// Called when you're done with editing or adding a new product to make editedProduct ready for another use.
  void resetEditedProduct() {
    editedProduct =  Product(
        id: '',
        title: '',
        description: '',
        price: Decimal.parse('0'),
        imageUrl: null,
        sizeQuantity: {});
    notifyListeners();
  }

  void callNotifyListeners() {
    notifyListeners();
  }

  List<Product> get products {
    return [..._items];
  }

  // Returns a copy so that the only way to add a
  // product is through our method which calls notifyListeners().
  // If you added to the returned original list, notifyListeners won't be called.
  List<Product> get favoriteProducts {
    return [..._items].where((product) => product.isFavorite).toList();
  }

  Future<void> determineFavoriteStatus(Product product) async {
    int index = _items.indexOf(product);
    if (index != -1) {
      
        await _productsController.updateProductFavoriteStatus(
            product.id, !product.isFavorite);
        _items[index] = product.copyWith(isFavorite: !product.isFavorite);
        notifyListeners();
      
    }
  }

  Future<void> getAndSetProducts() async {
    _items = await _productsController.getProducts();
    areProductsFetched = true;
    notifyListeners();
  }

  /// Adds the new product to the end of the list of products.
  Future<void> addProduct(Product newProduct, File imageFile) {
    return addProductByIndex(newProduct, _items.length, imageFile);
  }

  /// Inserts the new product at a specific index in the list of products.
  ///
  /// Throws an excpetion if operation fails.
  Future<void> addProductByIndex(
      Product newProduct, int index, File imageFile) async {
    Product newpProductWithImageUrl =
        await _productsController.create(newProduct, imageFile);
    _items.insert(index, newpProductWithImageUrl);
    notifyListeners();
  }

  Future<void> updateProduct(Product newProduct, File? imageFile) async {
    //TODO: find the obejct itself
    final index = _items.indexWhere((element) => element.id == newProduct.id);
    if (index >= 0) {
      Product product =
          await _productsController.updateProduct(newProduct, imageFile);
      _items[index] = product;
      notifyListeners();
    }
  }

  /// Used for cartItem's product because it is not updated.
  Map<String, int> getProductSizeQuantity(Product product, String size) {
    int index = _items.indexOf(product);
    Map<String, int> sizeQuantity = _items[index].sizeQuantity;
    return sizeQuantity;
  }

  Future<void> deleteProductSize(Product product, String size) async {
    await _productsController.deleteProductSize(product, size).then((value) {
      int index = products.indexOf(product);
      Map<String, int> sizeQuantity = Map.from(products[index].sizeQuantity);
      sizeQuantity.remove(size);
      _items[index] = _items[index].copyWith(sizeQuantity: sizeQuantity);
      notifyListeners();
    });
  }

  /// Decreases the quantity of a size by a certain amount after it has been ordered.
  Future<int> reduceSizeQuantity(
      Product product, String size, int quantity) async {
    late int newQuantity;
    await _productsController
        .decrementSizeQuantity(product, size, quantity)
        .then((value) {
      int index = _items.indexOf(product);
      Map<String, int> sizeQuantity = Map.from(_items[index].sizeQuantity);
      sizeQuantity.update(size, (value) {
        newQuantity = value - quantity;
        return newQuantity;
      });
      _items[index] = _items[index].copyWith(sizeQuantity: sizeQuantity);
    });
    return newQuantity;
  }

  Product? getProductById(String id) {
    for (Product product in products) {
      if (product.id == id) {
        {
          return product;
        }
      }
    }
    return null;
  }

  /// Deletes a product from the products list by id and returns its index.
  Future<int> deleteProduct(String productId, {bool deleteImage = true}) async {
    await _productsController.delete(productId, deleteImage);
    int index = -1;
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].id == productId) {
        index = i;
      }
    }
    if (index != -1) {
      _items.removeAt(index);
      notifyListeners();
    } else {
      // product not found in list
      throw ProductUnavailableException(
          "Deleting failed! Product not available.");
    }
    return index;
  }

  // called when user logs out to reset all provider's data
  void reset() {
    _items = [];
  }
}

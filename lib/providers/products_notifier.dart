import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/controllers/excpetion_handler.dart';
import 'package:store_app/controllers/product_controller.dart';

import '../models/product/product.dart';
import '../services/app_exception.dart';

class ProductsNotifier with ChangeNotifier, ExceptionHandler {
  bool areProductsFetched = false;

  ProductsNotifier(this.items);
  late final ProductController _productsController = ProductController();
  Product editedProduct = const Product(
      id: '', title: '', description: '', price: 0, imageUrl: null);

  /// Called when you're done with editing or adding a new product to make editedProduct ready for another use.
  void resetEditedProduct() {
    editedProduct = const Product(
        id: '',
        title: '',
        description: '',
        price: 0,
        imageUrl: null,
        sizeQuantity: {});
    notifyListeners();
  }

  void callNotifyListeners() {
    notifyListeners();
  }

  List<Product> get products {
    return [...items];
  }

  // Returns a copy so that the only way to add a
  // product is through our method which calls notifyListeners().
  // If you added to the returned original list, notifyListeners won't be called.
  List<Product> get favoriteProducts {
    return [...items].where((product) => product.isFavorite).toList();
  }

  Future<void> determineFavoriteStatus(Product product) async {
    int index = items.indexOf(product);
    if (index != -1) {
      try {
        await _productsController.updateProductFavoriteStatus(
            product.id, !product.isFavorite);
        items[index] = product.copyWith(isFavorite: !product.isFavorite);
        notifyListeners();
      } catch (e) {
        handleException(e);
      }
    }
  }

  Future<void> getAndSetProducts() async {
    items = await _productsController.getProducts();
    areProductsFetched = true;
    notifyListeners();
  }

  /// Adds the new product to the end of the list of products.
  Future<void> addProduct(Product newProduct, File imageFile) {
    return addProductByIndex(newProduct, items.length, imageFile);
  }

  /// Inserts the new product at a specific index in the list of products.
  ///
  /// Throws an excpetion if operation fails.
  Future<void> addProductByIndex(
      Product newProduct, int index, File imageFile) async {
    Product newpProductWithImageUrl =
        await _productsController.create(newProduct, imageFile);
    items.insert(index, newpProductWithImageUrl);
    notifyListeners();
  }

  Future<void> updateProduct(Product newProduct, File? imageFile) async {
    //TODO: find the obejct itself
    final index = items.indexWhere((element) => element.id == newProduct.id);
    if (index >= 0) {
      Product product =
          await _productsController.updateProduct(newProduct, imageFile);
      items[index] = product;
      notifyListeners();
    }
  }

  /// Used for cartItem's product because it is not updated.
  Map<String, int> getProductSizeQuantity(Product product, String size) {
    int index = items.indexOf(product);
    Map<String, int> sizeQuantity = items[index].sizeQuantity;
    return sizeQuantity;
  }

  Future<void> deleteProductSize(Product product, String size) async {
    await _productsController.deleteProductSize(product, size).then((value) {
      int index = products.indexOf(product);
      Map<String, int> sizeQuantity = Map.from(products[index].sizeQuantity);
      sizeQuantity.remove(size);
      items[index] = items[index].copyWith(sizeQuantity: sizeQuantity);
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
      int index = items.indexOf(product);
      Map<String, int> sizeQuantity = Map.from(items[index].sizeQuantity);
      sizeQuantity.update(size, (value) {
        newQuantity = value - quantity;
        return newQuantity;
      });
      items[index] = items[index].copyWith(sizeQuantity: sizeQuantity);
    });
    return newQuantity;
  }

  /// Deletes a product from the products list by id and returns its index.
  Future<int> deleteProduct(String productId) async {
    await _productsController.delete(productId);
    int index = -1;
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == productId) {
        index = i;
      }
    }
    if (index != -1) {
      items.removeAt(index);
      notifyListeners();
    } else {
      // product not found in list
      throw ProductUnavailableException(
          "Deleting failed! Product not available.");
    }
    return index;
  }

  // TODO: make it private
  List<Product> items = [];
}

import 'package:flutter/material.dart';
import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/controllers/products_controller.dart';

import '../models/product/product.dart';
import '../services/app_exception.dart';

class ProductsNotifier with ChangeNotifier, ErrorHandler {
  bool areProductsFetched = false;

  ProductsNotifier(this.items);
  late final ProductsController _productsController = ProductsController();
  Product editedProduct =
      const Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  /// Called when you're done with editing or adding a new product to make editedProduct ready for another use.
  void resetEditedProduct() {
    editedProduct = const Product(
        id: '', title: '', description: '', price: 0, imageUrl: '');
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
        await _productsController.determineFavoriteStatus(
            product.id, !product.isFavorite);
        items[index] = product.copyWith(isFavorite: !product.isFavorite);
        notifyListeners();
      } catch (e) {
        handleError(e);
      }
    }
  }

  Future<void> getAndSetProducts() async {
    items = await _productsController.getProducts();
    areProductsFetched = true;
    notifyListeners();
  }

  /// Adds the new product to the end of the list of products.
  Future<void> addProduct(Product newProduct) {
    return addProductByIndex(newProduct, items.length);
  }

  /// Inserts the new product at a specific index in the list of products.
  ///
  /// Throws an excpetion if operation fails.
  Future<void> addProductByIndex(Product newProduct, int index) async {
    await _productsController.create(newProduct);
    items.insert(index, newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product newProduct) async {
    //TODO: find the obejct itself
    final index = items.indexWhere((element) => element.id == newProduct.id);
    if (index >= 0) {
      await _productsController.updateProduct(newProduct);
      items[index] = newProduct;
      notifyListeners();
    }
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

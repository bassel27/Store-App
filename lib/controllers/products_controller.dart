import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/models/constants.dart';

import '../models/product/product.dart';
import '../services/base_client.dart';

// TODO: use tojson and from json. send my id
class ProductsController with ErrorHandler {
  String authToken;
  ProductsController(this.authToken);

  /// Returns list of products.
  ///
  /// Throws excpetion if operation fails.
  Future<List<Product>> get() async {
    Map<String, dynamic>? extracedData;
    extracedData = await BaseClient.get("$kProductsUrl?auth=$authToken");
    List<Product>? loadedProducts = [];
    if (extracedData != null) {
      // if fetching succeeded but there are no products
      extracedData.forEach((_, prodData) {
        loadedProducts.add(Product.fromJson(prodData));
      });
    }

    return loadedProducts;
  }

  /// Throws an error if operation fails.
  Future<void> toggleFavoriteStatus(Product product) async {
    var productUrl = "$kBaseUrl/products/${product.id}.json";
    await BaseClient.patch(
        productUrl, // delete, patch and put don't throw their own errors
        {
          "isFavorite": product.isFavorite,
        },
        timeOutDuration: 1);
  }

  /// Throws an exception if operation fails.
  Future<void> create(Product newProduct) async {
    DialogHelper.showLoading();
    await BaseClient.put(
        "$kProductsBaseUrl/${newProduct.id}.json", newProduct.toJson());
    DialogHelper.hideCurrentDialog();
  }

  /// Throws an exception if operation fails.
  Future<void> updateProduct(Product newProduct) async {
    DialogHelper.showLoading();
    var oldProductUrl = "$kBaseUrl/products/${newProduct.id}.json";
    await BaseClient.patch(oldProductUrl, newProduct.toJson());
    DialogHelper.hideCurrentDialog();
  }

  Future<void> delete(String productId) async {
    String deletedProductUrl = "$kBaseUrl/products/$productId.json";
    await BaseClient.delete(deletedProductUrl);
  }
}

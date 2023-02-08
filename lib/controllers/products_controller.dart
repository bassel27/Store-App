import 'package:store_app/controllers/base_controller.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/models/constants.dart';

import '../models/product/product.dart';
import '../services/base_client.dart';

class ProductsController with BaseController {
  /// Returns list of products or null if no products or if exception thrown.
  Future<List<Product>?> get() async {
    Map<String, dynamic>? extracedData;
    extracedData = await BaseClient.get(kProductsUrl);
    List<Product>? loadedProducts = [];
    if (extracedData != null) {
      // if fetching succeeded but there are no products
      extracedData.forEach((prodId, prodData) {
        loadedProducts!.add(Product(
          id: prodId,
          description: prodData['description'],
          price: prodData['price'],
          title: prodData['title'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
    } else {
      loadedProducts = null;
    }

    return loadedProducts;
  }

  /// Handles errors and rethrows them .
  Future<void> toggleFavoriteStatus(Product product) async {
    var productUrl = "$kBaseUrl/products/${product.id}.json";
    try {
      await BaseClient.patch(
          productUrl, // delete, patch and put don't throw their own errors
          {
            "isFavorite": product.isFavorite,
          },
          timeOutDuration: 1);
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  /// Returns product id or null if product not added successfully.
  Future<String?> create(Product newProduct) async {
    DialogHelper.showLoading();
    Map responseBody;
    try {
      responseBody = await BaseClient.post(kProductsUrl, {
        "title": newProduct.title,
        "description": newProduct.description,
        "imageUrl": newProduct.imageUrl,
        "price": newProduct.price,
        "isFavorite": newProduct.isFavorite,
      });
    } catch (e) {
      handleError(e);
      rethrow;
    }
    DialogHelper.hideCurrentDialog();
    return BaseClient.getObjectIdByResponse(responseBody);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    DialogHelper.showLoading();
    var oldProductUrl = "$kBaseUrl/products/$id.json";
    try {
      await BaseClient.patch(oldProductUrl, {
        "title": newProduct.title,
        "description": newProduct.description,
        "imageUrl": newProduct.imageUrl,
        "price": newProduct.price,
      });
    } catch (e) {
      handleError(e);
      rethrow;
    }
    DialogHelper.hideCurrentDialog();
  }

  Future<void> delete(String productId) async {
    String deletedProductUrl = "$kBaseUrl/products/$productId.json";
    await BaseClient.delete(deletedProductUrl);
  }
}

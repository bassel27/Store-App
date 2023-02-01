import 'package:store_app/controllers/base_controller.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/models/product.dart';

import '../services/base_client.dart';

class ProductsController with BaseController {
  /// Returns list of products or null if no products or if exception thrown.
  Future<List<Product>?> fetchProducts() async {
    DialogHelper.showLoading();
    Map<String, dynamic>? extracedData;

    try {
      extracedData = await BaseClient.get(kProductsUrl);
    } catch (e) {
      handleError(e);
      return null;
    }
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
    DialogHelper.hideCurrentDialog();
    return loadedProducts;
  }
}

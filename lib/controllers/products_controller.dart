import 'package:store_app/controllers/base_controller.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/models/product.dart';

import '../services/base_client.dart';

class ProductsController with BaseController {
  /// Returns list of products or null if no products or if exception thrown.
  Future<List<Product>?> fetchProducts() async {

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
}

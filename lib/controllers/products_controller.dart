import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/mixins/add_token_to_url.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/providers/auth_notifier.dart';

import '../models/product/product.dart';
import '../services/base_client.dart';

// TODO: use tojson and from json. send my id
class ProductsController with ErrorHandler, AddTokenToUrl {
  AuthNotifier authProvider;
  ProductsController(this.authProvider);

  /// Returns list of products.
  ///
  /// Throws excpetion if operation fails.
  Future<List<Product>> getProducts() async {
    Map<String, dynamic>? extracedData;
    extracedData = await BaseClient.get(
        getTokenedUrl(url: kProductsUrl, token: authProvider.token!));
    var productToIsFavoriteDict = await BaseClient.get(getTokenedUrl(
        url: "$kUserFavoritesBaseUrl/${authProvider.userId}" ".json",
        token: authProvider.token!));
    List<Product>? loadedProducts = [];
    if (extracedData != null) {
      // if fetching succeeded but there are no products
      extracedData.forEach((_, prodData) {
        Product product = Product.fromJson(prodData);
        if (productToIsFavoriteDict != null) {
          // if user has favorites
          bool? isThisProductInFavoritesList =
              productToIsFavoriteDict[product.id];
          if (isThisProductInFavoritesList != null) {
            // if this product is mentioned int he favorites list
            product =
                product.copyWith(isFavorite: isThisProductInFavoritesList);
          }
        }
        loadedProducts.add(product);
      });
    }

    return loadedProducts;
  }

  /// Throws an error if operation fails.
  Future<void> determineFavoriteStatus(
      String productId, bool isFavorite, String userId) async {
    DialogHelper.showLoading();
    var url = "$kUserFavoritesBaseUrl/$userId.json";
    await BaseClient.patch(
        getTokenedUrl(
            url: url,
            token: authProvider
                .token!), // delete, patch and put don't throw their own errors
        {
          productId: isFavorite,
        });
    DialogHelper.hideCurrentDialog();
  }

  /// Throws an exception if operation fails.
  Future<void> create(Product newProduct) async {
    DialogHelper.showLoading();
    await BaseClient.put(
        getTokenedUrl(
            url: "$kProductsBaseUrl/${newProduct.id}.json",
            token: authProvider.token!),
        newProduct.toJson());
    DialogHelper.hideCurrentDialog();
  }

  /// Throws an exception if operation fails.
  Future<void> updateProduct(Product newProduct) async {
    DialogHelper.showLoading();
    var oldProductUrl = "$kBaseUrl/products/${newProduct.id}.json";
    await BaseClient.patch(
        getTokenedUrl(url: oldProductUrl, token: authProvider.token!),
        newProduct.toJson());
    DialogHelper.hideCurrentDialog();
  }

  Future<void> delete(String productId) async {
    String deletedProductUrl = "$kBaseUrl/products/$productId.json";
    await BaseClient.delete(
        getTokenedUrl(url: deletedProductUrl, token: authProvider.token!));
  }
}

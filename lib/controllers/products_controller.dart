import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/mixins/add_token_to_url.dart';

import '../models/product/product.dart';

// TODO: use tojson and from json. send my id
class ProductsController with ErrorHandler, AddTokenToUrl {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final String kProductsCollection = 'products';

  /// Returns list of products.
  ///
  /// Throws excpetion if operation fails.
  Future<List<Product>> getProducts() async {
    List<Product> products = [];
    QuerySnapshot snapshot = await db.collection(kProductsCollection).get();
    for (var docSnapshot in snapshot.docs) {
      products
          .add(Product.fromJson(docSnapshot.data() as Map<String, dynamic>));
    }
    return products;
  }

  /// Throws an exception if operation fails.
  Future<void> create(Product newProduct) async {
    DialogHelper.showLoading();
    await db
        .collection(kProductsCollection)
        .doc(newProduct.id)
        .set(newProduct.toJson());
    DialogHelper.hideCurrentDialog();
  }

  /// Throws an error if operation fails.
  Future<void> determineFavoriteStatus(
      String productId, bool isFavorite, String userId) async {
    DialogHelper.showLoading();
    await db
        .collection(kProductsCollection)
        .doc(productId)
        .set({'isFavorite': isFavorite}, SetOptions(merge: true));
    DialogHelper.hideCurrentDialog();
  }

  /// Throws an exception if operation fails.
  Future<void> updateProduct(Product newProduct) async {
    DialogHelper.showLoading();
    await db
        .collection(kProductsCollection)
        .doc(newProduct.id)
        .set(newProduct.toJson(), SetOptions(merge: true));
    DialogHelper.hideCurrentDialog();
  }

  Future<void> delete(String productId) async {
    DialogHelper.showLoading();
    await db.collection(kProductsCollection).doc(productId).delete();
    DialogHelper.hideCurrentDialog();
  }
}

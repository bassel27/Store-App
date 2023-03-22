import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/mixins/add_token_to_url.dart';

import '../models/product/product.dart';

// TODO: use tojson and from json. send my id
class ProductsController with ErrorHandler, AddTokenToUrl {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final String kProductsCollection = 'products';
  late final List<String> _favoriteProductIds;

  /// Returns list of products.
  ///
  /// Throws excpetion if operation fails.
  Future<List<Product>> getProducts() async {
    await _setFavoriteProductsIds();
    List<Product> products = [];
    QuerySnapshot snapshot = await db.collection(kProductsCollection).get();
    for (var docSnapshot in snapshot.docs) {
      Product product =
          Product.fromJson(docSnapshot.data() as Map<String, dynamic>);
      if (isProductFavorite(product.id)) {
        product = product.copyWith(isFavorite: true);
      }
      products.add(product);
    }
    return products;
  }

  /// Throws an exception if operation fails.
  Future<Product> create(Product newProduct, File imageFile) async {
    DialogHelper.showLoading();
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('product_image')
        .child(newProduct.id);
    await ref.putFile(imageFile).whenComplete(() => null);
    Product newProductWithImageUrl =
        newProduct.copyWith(imageUrl: await ref.getDownloadURL());
    db
        .collection(kProductsCollection)
        .doc(newProduct.id)
        .set(newProductWithImageUrl.toJson());
    DialogHelper.hideCurrentDialog();
    return newProductWithImageUrl;
  }

  /// Throws an error if operation fails.
  Future<void> determineFavoriteStatus(
      String productId, bool isFavorite) async {
    DialogHelper.showLoading();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var usersCollection = db.collection('users');
    if (isFavorite) {
      await usersCollection.doc(userId).update({
        'favorite_products': FieldValue.arrayUnion([productId]),
      });
    } else {
      await usersCollection.doc(userId).update({
        'favorite_products': FieldValue.arrayRemove([productId]),
      });
    }
    DialogHelper.hideCurrentDialog();
  }

  Future<void> _setFavoriteProductsIds() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await db.collection('users').doc(userId).get();
    _favoriteProductIds = List<String>.from(userDoc['favorite_products']);
  }

  bool isProductFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      return true;
    } else {
      return false;
    }
  }

  /// Throws an exception if operation fails.
  Future<Product> updateProduct(Product newProduct, File? imageFile) async {
    DialogHelper.showLoading();
    Product newProductWithImageUrl = newProduct;
    if (imageFile == null) {
      // use old image
      await db
          .collection(kProductsCollection)
          .doc(newProduct.id)
          .set(newProduct.toJson(), SetOptions(merge: true));
    } else {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('product_image')
          .child(newProduct.id);
      await deleteImageFile(newProduct.id);
      await ref.putFile(imageFile).whenComplete(() => null);
      newProductWithImageUrl =
          newProduct.copyWith(imageUrl: await ref.getDownloadURL());

      db
          .collection(kProductsCollection)
          .doc(newProduct.id)
          .set(newProductWithImageUrl.toJson());
    }
    DialogHelper.hideCurrentDialog();
    return newProductWithImageUrl;
  }

  Future<void> delete(String productId) async {
    DialogHelper.showLoading();
    await deleteImageFile(productId);
    await db.collection(kProductsCollection).doc(productId).delete();
    DialogHelper.hideCurrentDialog();
  }

  Future<void> deleteImageFile(String productId) async {
    final desertRef =
        FirebaseStorage.instance.ref().child('product_image').child(productId);
    await desertRef.delete();
  }
}

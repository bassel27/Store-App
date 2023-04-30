import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:store_app/controllers/excpetion_handler.dart';
import 'package:store_app/helper/dialog_helper.dart';

import '../models/product/product.dart';

// TODO: use tojson and from json. send my id
class ProductController with ExceptionHandler {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final String kProductsCollection = 'products';
  late List<String> _favoriteProductIds;

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
    _deleteOldFavoriteProducts(products);
    return products;
  }

  /// Throws an exception if operation fails.
  Future<Product> create(Product newProduct, File imageFile) async {
    DialogHelper.showLoading();
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('productImages')
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
  Future<void> updateProductFavoriteStatus(
      String productId, bool isFavorite) async {
    DialogHelper.showLoading();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var usersCollection = db.collection('users');
    if (isFavorite) {
      await usersCollection.doc(userId).update({
        'favoriteProducts': FieldValue.arrayUnion([productId]),
      });
    } else {
      await usersCollection.doc(userId).update({
        'favoriteProducts': FieldValue.arrayRemove([productId]),
      });
    }
    DialogHelper.hideCurrentDialog();
  }

  /// Sets favoriteProductIds variable.
  Future<void> _setFavoriteProductsIds() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await db.collection('users').doc(userId).get();
    _favoriteProductIds = List<String>.from(userDoc['favoriteProducts']);
  }

  /// Provide products list to delete favorite products that no longer exist.
  Future<void> _deleteOldFavoriteProducts(List<Product> products) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Filter out any productIds that do not exist in the `products` list
    final List<String> validProductIds = _favoriteProductIds.where((productId) {
      return products.any((product) => product.id == productId);
    }).toList();

    if (validProductIds.length != _favoriteProductIds.length) {
      await db.collection('users').doc(userId).update({
        'favoriteProducts': validProductIds,
      });
    }

    _favoriteProductIds = validProductIds;
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
          .child('productImages')
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
    await db.collection(kProductsCollection).doc(productId).delete();
    await deleteImageFile(productId);
    DialogHelper.hideCurrentDialog();
  }

  Future<void> deleteProductSize(Product product, String size) async {
    await db
        .collection(kProductsCollection)
        .doc(product.id)
        .update({'sizeQuantity.$size': FieldValue.delete()});
  }

  Future<void> decrementSizeQuantity(
      Product product, String size, int quantity) async {
    await db
        .collection(kProductsCollection)
        .doc(product.id)
        .update({'sizeQuantity.$size': FieldValue.increment(-quantity)});
  }

  Future<void> deleteImageFile(String productId) async {
    try {
      final desertRef = FirebaseStorage.instance
          .ref()
          .child('productImages')
          .child(productId);
      await desertRef.delete();
    } on PlatformException catch (e) {
      if (e.code == 'firebase_storage' || e.code == 'object-not-found') {
        // image not found to delete
      } else {
        rethrow;
      }
    } on FirebaseException catch (e) {
      if (e.code == 'firebase_storage/object-not-found' ||
          e.message == 'No object exists at the desired reference.') {
      } else {
        rethrow;
      }
    }
  }
}

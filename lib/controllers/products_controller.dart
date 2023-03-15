import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  Future<Product> create(Product newProduct, File imageFile) async {
    DialogHelper.showLoading();
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('product_image')
        .child(newProduct.id);

    // Use a transaction to ensure that both the image and the product information are uploaded successfully
    Product newProductWithImageUrl =
        await FirebaseFirestore.instance.runTransaction((transaction) async {
      await ref.putFile(imageFile).whenComplete(() => null);
      Product newProductWithImageUrl =
          newProduct.copyWith(imageUrl: await ref.getDownloadURL());
      transaction.set(
        db.collection(kProductsCollection).doc(newProduct.id),
        newProductWithImageUrl.toJson(),
      );
      return newProductWithImageUrl;
    });
    DialogHelper.hideCurrentDialog();
    return newProductWithImageUrl;
  }

  /// Throws an error if operation fails.
  Future<void> determineFavoriteStatus(
      String productId, bool isFavorite) async {
    DialogHelper.showLoading();
    await db
        .collection(kProductsCollection)
        .doc(productId)
        .set({'isFavorite': isFavorite}, SetOptions(merge: true));
    DialogHelper.hideCurrentDialog();
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
      newProductWithImageUrl =
          await FirebaseFirestore.instance.runTransaction((transaction) async {
        await deleteImageFile(newProduct.id);
        await ref.putFile(imageFile).whenComplete(() => null);
        Product newProductWithImageUrl =
            newProduct.copyWith(imageUrl: await ref.getDownloadURL());
        transaction.set(
          db.collection(kProductsCollection).doc(newProduct.id),
          newProductWithImageUrl.toJson(),
        );
        return newProductWithImageUrl;
      });
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

import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, QuerySnapshot;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/controllers/excpetion_handler.dart';

import '../models/order/order.dart';

class OrderController with ExceptionHandler {
  OrderController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final String kOrdersCollection = 'orders';

  /// Returns fetched orders.
  ///
  /// Throws an exception if operation fails.
  Future<List<Order>> get(bool isAdmin ) async {
    List<Order> products = [];
    QuerySnapshot snapshot;
    if (!isAdmin) {
      snapshot = await db
          .collection(kOrdersCollection)
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
    } else {
      snapshot = await db.collection(kOrdersCollection).get();
    }
    for (var docSnapshot in snapshot.docs) {
      products.add(Order.fromJson(docSnapshot.data() as Map<String, dynamic>));
    }
    return products;
  }

  /// Returns post ID and handles error using dialog.
  ///
  /// Throws exception if operation not successful.
  Future<void> create(Order newOrder) async {
    await db
        .collection(kOrdersCollection)
        .doc(newOrder.id)
        .set(newOrder.toJson());
  }
}

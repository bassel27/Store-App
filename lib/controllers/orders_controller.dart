import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, QuerySnapshot;
import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/mixins/add_token_to_url.dart';

import '../models/order/order.dart';

class OrdersController with ErrorHandler, AddTokenToUrl {
  OrdersController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final String kOrdersCollection = 'orders';

  /// Returns fetched orders.
  ///
  /// Throws an exception if operation fails.
  Future<List<Order>> get() async {
    List<Order> products = [];
    QuerySnapshot snapshot = await db.collection(kOrdersCollection).get();
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

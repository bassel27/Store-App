import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, FirebaseFirestore, Query, QueryDocumentSnapshot, QuerySnapshot;
    
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/data/models/order/order.dart';

import 'excpetion_handler.dart';


class OrderController with ExceptionHandler {
  OrderController();
  final String kOrdersCollection = 'orders';
  DocumentSnapshot? _startAfter;
  late final _ordersCollection =
      FirebaseFirestore.instance.collection(kOrdersCollection);

  /// Returns fetched orders.
  ///
  /// Throws an exception if operation fails.
  Future<List<Order>> getOrdersByBatch(bool isAdmin,
      numberOfOrdersToFetch ) async {
    late Query ordersQuery;

    if (isAdmin) {
      ordersQuery = _ordersCollection.orderBy('dateTime', descending: true);
    } else {
      ordersQuery = _ordersCollection
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('dateTime', descending: true);
    }

    if (_startAfter != null) {
      ordersQuery = ordersQuery.startAfterDocument(_startAfter!);
    }

    ordersQuery = ordersQuery.limit(numberOfOrdersToFetch);

    final querySnapshot = await ordersQuery.get();
    final ordersDocs = querySnapshot.docs;
    final List<Order> orders = [];

    for (final doc in ordersDocs) {
      final order = Order.fromJson(doc.data() as Map<String, dynamic>);
      orders.add(order);
    }
    if (ordersDocs.isNotEmpty) {
      _startAfter = ordersDocs.last;
    }
    return orders;
  }

  /// Returns post ID and handles error using dialog.
  ///
  /// Throws exception if operation not successful.
  Future<void> create(Order newOrder) async {
    await _ordersCollection.doc(newOrder.id).set(newOrder.toJson());
  }

  setOrderStatus(String orderId, bool isDone)async{
    await _ordersCollection.doc(orderId).update({'isDone': isDone});
  }
}

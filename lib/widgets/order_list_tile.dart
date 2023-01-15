import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_item.dart';
import '../providers/orders.dart';

class OrderListTile extends StatelessWidget {
  OrderItem order;
  OrderListTile(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("\$ ${order.amount.toString()}"),
        subtitle: Text(
          //TODO: format date
          order.dateTime.toString(),
        ),
        trailing: IconButton(
          icon: Icon(Icons.expand_more),
          onPressed: () {},
        ),
      ),
    );
  }
}

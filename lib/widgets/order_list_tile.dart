import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart';

class OrderListTile extends StatefulWidget {
  OrderItem order;
  OrderListTile(this.order);

  @override
  State<OrderListTile> createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("\$ ${widget.order.amount.toStringAsFixed(2)}"),
            subtitle: Text(
              DateFormat("dd/MM/yyyy, hh:mm a").format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              height: min(widget.order.numberOfProducts * 20.0 + 10, 100),
              child: ListView(
                  children: widget.order.products
                      .map(
                        (product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${product.name}"),
                            Text("${product.quantity}x ${product.price}"),
                          ],
                        ),
                      )
                      .toList()),
            ),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

// TODO: fix order added even if you press order now on zero/ empty cart.
class OrderListTile extends StatefulWidget {
  Order order;
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
          Material(
            elevation: 3,
            child: ListTile(
              title: Text("\$ ${widget.order.total.toStringAsFixed(2)}"),
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
          ),
          // if (isExpanded)
          //   const Divider(
          //     thickness: 1.5,
          //   ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: min(widget.order.numberOfProducts * 16.0 + 20, 80),
              child: ListView(
                  children: widget.order.cartItems
                      .map(
                        (cartItem) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(cartItem.product.title),
                            Text(
                                "${cartItem.quantity}x ${cartItem.product.price}"),
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

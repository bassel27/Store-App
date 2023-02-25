import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/widgets/cart_item_tile.dart';

import '../models/order/order.dart';

// TODO: fix order added even if you press order now on zero/ empty cart.
class OrderListTile extends StatefulWidget {
  Order order;
  OrderListTile(this.order);

  @override
  State<OrderListTile> createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  bool isExpanded = false;
  var myBorderSide = const BorderSide(color: Colors.grey, width: 1);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Card(
        child: Column(
          children: [
            mainContainer(),
            if (isExpanded)
              _dropDownContainer(myBorderSide: myBorderSide, widget: widget),
          ],
        ),
      ),
    );
  }

  Material mainContainer() {
    return Material(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: myBorderSide,
            left: myBorderSide,
            top: myBorderSide,
          ),
        ),
        child: ListTile(
          title: Text("$kCurrency ${widget.order.total.toStringAsFixed(2)}"),
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
    );
  }
}

class _dropDownContainer extends StatelessWidget {
  const _dropDownContainer({
    Key? key,
    required this.myBorderSide,
    required this.widget,
  }) : super(key: key);

  final BorderSide myBorderSide;
  final OrderListTile widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: myBorderSide,
          left: myBorderSide,
          bottom: myBorderSide,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: min(widget.order.numberOfProducts * 60 + 40, 230),
      child: ListView(
          children: widget.order.cartItems
              .map((cartItem) => CartItemTile(cartItem: cartItem))
              .toList()),
    );
  }
}

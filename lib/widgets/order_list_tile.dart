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
            _dropDownContainer(
              myBorderSide: myBorderSide,
              widget: widget,
              isExpanded: isExpanded,
            ),
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
            DateFormat("dd/MM/yyyy").format(widget.order.dateTime),
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
    required this.isExpanded,
  }) : super(key: key);
  final bool isExpanded;
  final BorderSide myBorderSide;
  final OrderListTile widget;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          isExpanded ? min(widget.order.numberOfProducts * 75 + 40, 230) : 0,
      decoration: BoxDecoration(
        border: Border(
          right: myBorderSide,
          left: myBorderSide,
          bottom: myBorderSide,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListView(
          children: widget.order.cartItems
              .map((cartItem) => CartItemTile(cartItem: cartItem))
              .toList()),
    );
  }
}

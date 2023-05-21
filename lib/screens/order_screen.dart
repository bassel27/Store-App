import 'package:flutter/material.dart';
import 'package:store_app/models/address/address.dart';

import '../models/order/order.dart';
import '../widgets/cart_item_tile.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen();

  static const route = '';
  final myBorderSide = const BorderSide(color: Colors.grey, width: 2);
  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;

    final Address address = order.address;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Address",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
            _AddressInfoWidget(
              label: 'First name',
              value: address.firstName,
            ),
            _AddressInfoWidget(
              label: 'Last name',
              value: address.lastName,
            ),
            _AddressInfoWidget(
              label: 'Address',
              value: address.address,
            ),
            _AddressInfoWidget(
              label: 'City',
              value: address.city,
            ),
            _AddressInfoWidget(
              label: 'Mobile number',
              value: address.mobileNumber,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Order Items",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      right: myBorderSide,
                      left: myBorderSide,
                      top: myBorderSide),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: ListView(
                    children: order.cartItems
                        .map((cartItem) => CartItemTile(cartItem: cartItem))
                        .toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressInfoWidget extends StatelessWidget {
  final String label;
  final String value;

  const _AddressInfoWidget({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style:
              const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
          children: [
            TextSpan(
              text: '$label: ',
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    );
  }
}

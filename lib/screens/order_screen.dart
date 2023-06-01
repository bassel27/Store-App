import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/address/address.dart';
import 'package:store_app/widgets/currency_and_price_text.dart';

import '../models/order/order.dart';
import '../widgets/cart_item_tile.dart';

const myBorderSide = BorderSide(color: Colors.grey, width: 2);

class OrderScreen extends StatelessWidget {
  const OrderScreen();

  static const route = '';
  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;
    const TextStyle titleTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 25,
      shadows: [Shadow(color: Colors.black, offset: Offset(0, -5))],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationColor: Colors.black,
      decorationThickness: 1,
    );
    final Address address = order.address;
    const belowTitleSizedBox = SizedBox(
      height: 10,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Address",
                style: titleTextStyle,
              ),
            ),
            belowTitleSizedBox,
            AddressColumn(address: address),
            const SizedBox(
              height: 15,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Order Items",
                style: titleTextStyle,
              ),
            ),
            belowTitleSizedBox,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        right: myBorderSide,
                        left: myBorderSide,
                        bottom: myBorderSide,
                        top: myBorderSide),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                            children: order.cartItems
                                .map((cartItem) =>
                                    CartItemTile(cartItem: cartItem))
                                .toList()),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            const Text("Total: ",
                                style: TextStyle(fontSize: 25)),
                            CurrencyAndPriceText(price: order.total),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressColumn extends StatelessWidget {
  const AddressColumn({
    Key? key,
    required this.address,
  }) : super(key: key);

  final Address address;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
            right: myBorderSide,
            left: myBorderSide,
            top: myBorderSide,
            bottom: myBorderSide),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Column(
        children: [
          _AddressInfoWidget(
            label: 'Name',
            value: "${address.firstName} ${address.lastName}",
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
        ],
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
      child: AutoSizeText.rich(
        TextSpan(
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.black,
            fontSize: 17,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
        maxLines: 1,
      ),
    );
  }
}

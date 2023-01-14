import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  final double price;
  const PriceText(this.price);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "EGP ${price.toString()}",
      ),
    );
  }
}

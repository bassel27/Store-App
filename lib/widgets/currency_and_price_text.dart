import 'package:flutter/material.dart';

import '../models/constants.dart';

class CurrencyAndPriceText extends StatelessWidget {
  const CurrencyAndPriceText({
    Key? key,
    required this.price,
    this.sizeMultiplicationFactor = 1,
  }) : super(key: key);
  final double sizeMultiplicationFactor;
  final num price;

  @override
  Widget build(BuildContext context) {
    final bodyText2 = Theme.of(context).textTheme.bodyText2!;
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
            fontWeight: FontWeight.w300,
            fontSize: bodyText2.fontSize! * sizeMultiplicationFactor),
        children: [
          const TextSpan(text: "$kCurrency "),
          TextSpan(
              text: price.toString(),
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: bodyText2.fontSize! * sizeMultiplicationFactor,
                  )),
        ],
      ),
    );
  }
}

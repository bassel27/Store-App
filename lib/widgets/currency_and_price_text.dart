import 'package:flutter/material.dart';

import '../models/constants.dart';

class CurrencyAndPriceText extends StatelessWidget {
  const CurrencyAndPriceText({
    Key? key,
    required this.price,
  }) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(fontWeight: FontWeight.w300, fontSize: 13),
        children: [
          const TextSpan(text: "$kCurrency "),
          TextSpan(
              text: price.toString(),
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w500,
                  )),
        ],
      ),
    );
  }
}

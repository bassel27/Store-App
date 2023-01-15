import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:store_app/providers/cart_notifier.dart';
import '../providers/orders.dart';

class TotalContainer extends StatelessWidget {
  const TotalContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 2, color: Color.fromRGBO(116, 102, 102, .5)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total"),
            const Spacer(),
            Consumer<CartNotifier>(
              builder: (__, cart, _) => Chip(
                label: Text("${cart.total}"),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            TextButton(
              onPressed: () {
                CartNotifier cartNotifier =
                    Provider.of<CartNotifier>(context, listen: false);
                Provider.of<Orders>(context, listen: false).addOrder(
                    cartNotifier.items.values.toList(), cartNotifier.total);
                cartNotifier.clear();
              },
              child: const Text("Order Now"),
            )
          ],
        ),
      ),
    );
  }
}

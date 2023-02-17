import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_notifier.dart';

import '../providers/orders_notifier.dart';

class TotalContainer extends StatelessWidget {
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
              builder: (__, CartNotifier cart, _) => Chip(
                label: Text(cart.total.toStringAsFixed(2)),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            const _OrderButton(),
          ],
        ),
      ),
    );
  }
}

class _OrderButton extends StatefulWidget {
  const _OrderButton();

  @override
  State<_OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<_OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    CartNotifier cartProvider = Provider.of<CartNotifier>(context);
    return TextButton(
      onPressed: (cartProvider.cartItemsCount == 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<OrdersNotifier>(context, listen: false)
                    .addOrder(cartProvider.items, cartProvider.total);
                await cartProvider.clear();
              } catch (e) {}
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
              )))
          : Text(
              "Order Now",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
    );
  }
}

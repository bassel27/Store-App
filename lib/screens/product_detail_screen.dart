import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/widgets/currency_and_price_text.dart';

import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const route = 'productDetail';

  @override
  Widget build(BuildContext context) {
    late Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    // TODO: use provider
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 5),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                children: [
                  _ImageContainer(product: product),
                  const SizedBox(
                    height: 15,
                  ),
                  CurrencyAndPriceText(price: product.price),
                  Text("Descripton: ${product.description}"),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: double.infinity,
              child: Row(
                children: [
                  _DropdownMenu(product),
                  const SizedBox(
                    width: 10,
                  ),
                  const Expanded(child: _AddToCartButton()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DropdownMenu extends StatelessWidget {
  // TODO: max quantity of product not 10
  final List<int> quantityList = List<int>.generate(100, (i) => i + 1);
  String? dropdownValue;
  final Product product;
  _DropdownMenu(this.product);
  @override
  Widget build(BuildContext context) {
    final CartNotifier cartProvider = context.watch<CartNotifier>();
    CartItem? cartItem = cartProvider.getCartItem(product);
    dropdownValue ??= cartItem == null
        ? quantityList.first.toString()
        : cartItem.quantity.toString();

    return Container(
      padding: const EdgeInsets.only(left: 7),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      height: 40,
      margin: EdgeInsets.zero,
      child: DropdownButton(
        // iconEnabledColor: Theme.of(context).colorScheme.tertiary,
        value: dropdownValue,
        menuMaxHeight: 250,
        icon: const Icon(
          Icons.arrow_drop_up,
          color: kTextLightColor,
        ),
        elevation: 16,
        selectedItemBuilder: (BuildContext ctxt) {
          return quantityList
              .map(
                (quantityNumber) => DropdownMenuItem<String>(
                  value: quantityNumber.toString(),
                  child: Text(
                    quantityNumber.toString(),
                  ),
                ),
              )
              .toList();
        },
        style: const TextStyle(color: kTextLightColor),
        // underline: Container(
        //   height: 2,
        //   color: Theme.of(context).colorScheme.tertiary,
        // ),
        items: quantityList
            .map(
              (quantityNumber) => DropdownMenuItem<String>(
                value: quantityNumber.toString(),
                child: Text(
                  quantityNumber.toString(),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          dropdownValue = value!;
          cartProvider.setQuantity(product, int.parse(value));
        },
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: kAccentColor,
          ),
          onPressed: () {},
          child: const Text(
            "ADD TO CART",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.w500, color: kTextLightColor),
          )),
    );
  }
}

class _ImageContainer extends StatelessWidget {
  const _ImageContainer({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Image.network(
        product.imageUrl,
      ),
    );
  }
}

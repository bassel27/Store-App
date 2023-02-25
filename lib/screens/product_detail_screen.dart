import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/widgets/currency_and_price_text.dart';

import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static const route = 'productDetail';

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // TODO: max quantity of product not 10
  final List<int> quantityList = List<int>.generate(10, (i) => i + 1);
  late Product product = ModalRoute.of(context)!.settings.arguments as Product;
  late CartNotifier cartProvider =
      Provider.of<CartNotifier>(context, listen: false);
  late CartItem? cartItem = cartProvider.getCartItem(product);
  late String dropdownValue = cartItem == null
      ? quantityList.first.toString()
      : cartItem!.quantity.toString();

  @override
  Widget build(BuildContext context) {
    late CartNotifier cartProvider =
        Provider.of<CartNotifier>(context, listen: false);
    // TODO: use provider
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5),
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Row(
                children: [
                  DropdownButton(
                    value: dropdownValue,
                    elevation: 16,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    items: quantityList
                        .map(
                          (quantityNumber) => DropdownMenuItem<String>(
                            value: quantityNumber.toString(),
                            child: Text(quantityNumber.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                        cartProvider.setQuantity(product, int.parse(value));
                      });
                    },
                  ),
                  const SizedBox(
                    width: 14,
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

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: kAccentColor,
        ),
        onPressed: () {},
        child: const Text(
          "ADD TO CART",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500, color: kTextLightColor),
        ));
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/widgets/currency_and_price_text.dart';
import 'package:store_app/widgets/my_cached_network_image.dart';
import 'package:store_app/widgets/size_and_quantity_card.dart';

import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const route = '/bottom_nav_bar/product_details';

  @override
  Widget build(BuildContext context) {
    late Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    // TODO: use provider
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 10, bottom: 5, right: 5),
              children: [
                _ImageContainer(product: product),
                const SizedBox(
                  height: 15,
                ),
                CurrencyAndPriceText(price: product.price),
                product.description == null || product.description == ''
                    ? Container()
                    : Text("Descripton: ${product.description}"),
                // product.sizeQuantity.map((key, value) => SizeAndQuantityCard(onAdd: onAdd))
              ],
            ),
          ),
          SizedBox(
            // margin: const EdgeInsets.symmetric(horizontal: 5),
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              width: double.infinity,
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _BottomRow(product)),
            ),
          )
        ],
      ),
    );
  }
}

class _BottomRow extends StatefulWidget {
  final Product product;
  const _BottomRow(this.product);

  @override
  State<_BottomRow> createState() => _BottomRowState();
}

class _BottomRowState extends State<_BottomRow> {
  final List<int> quantityList = List<int>.generate(100, (i) => i + 1);

  late final CartNotifier cartProvider = context.read<CartNotifier>();
  late CartItem? cartItem = cartProvider.getCartItem(widget.product);
  late String dropdownValue = cartItem == null
      ? quantityList.first.toString()
      : cartItem!.quantity.toString();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        dropdownMenu(context),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: kAccentColor,
              ),
              onPressed: () {
                cartProvider.setQuantity(
                    widget.product, int.parse(dropdownValue));
              },
              child: const Text(
                "ADD TO CART",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: kTextLightColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container dropdownMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 7),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      height: 40,
      margin: EdgeInsets.zero,
      child: ButtonTheme(
        alignedDropdown: true,
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
          items: quantityList
              .map(
                (quantityNumber) => DropdownMenuItem<String>(
                  value: quantityNumber.toString(),
                  child: Text(
                    quantityNumber.toString(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              dropdownValue = value!;
            });
          },
        ),
      ),
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
      child: Hero(
        tag: product.id,
        child: MyCachedNetworkImage(product.imageUrl!),
      ),
    );
  }
}

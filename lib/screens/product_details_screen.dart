import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/widgets/currency_and_price_text.dart';
import 'package:store_app/widgets/fab_favorite.dart';
import 'package:store_app/widgets/my_cached_network_image.dart';
import 'package:store_app/widgets/product_grid_tile.dart';

import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const route = '/bottom_nav_bar/product_details';

  @override
  Widget build(BuildContext context) {
    late Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    // TODO: use provider
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Stack(children: [
                      _ImageContainer(product: product),
                      Align(
                          alignment: Alignment.topRight,
                          child: FABFavorite(product.id, 35)),
                      Align(
                          alignment: Alignment.topLeft,
                          child: _FABBack(product.id, 35)),
                    ]),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 5, right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    fontWeight: FontWeight.w700, fontSize: 22),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CurrencyAndPriceText(price: product.price),
                          product.description == null ||
                                  product.description == ''
                              ? Container()
                              : Text("Descripton: ${product.description}"),
                          const SizedBox(
                            height: 10,
                          ),
                          SizesRow(product: product),
                        ],
                      ),
                    ),
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
        ),
      ),
    );
  }
}

class SizesRow extends StatefulWidget {
  const SizesRow({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<SizesRow> createState() => _SizesRowState();
}

class _SizesRowState extends State<SizesRow> {
  String? selectedSize;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.product.sizeQuantity.keys
            .map((String size) => _SizeCard(size, (String selected) {
                  setState(() {
                    selectedSize = selected; // Update selected size
                  });
                }, selectedSize == size))
            .toList(),
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
    return Hero(
      tag: product.id,
      child: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              child: MyCachedNetworkImage(product.imageUrl!)),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: const Alignment(0, 0.6),
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SizeCard extends StatelessWidget {
  final String size;
  final bool isSelected;
  final Function(String) onSelected;
  _SizeCard(this.size, this.onSelected, this.isSelected);

  TextStyle sizeTextStyle = const TextStyle(
      color: kTextLightColor, fontWeight: FontWeight.bold, fontSize: 17);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected(size);
      },
      child: SizedBox(
        height: 40,
        width: 50,
        child: Card(
          color: isSelected ? kActiveColor : kInactiveColor,
          elevation: 4,
          child: Center(
            child: Text(size,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 17)),
          ),
        ),
      ),
    );
  }
}

class _FABBack extends FABFavorite {
  _FABBack(String productId, double circleDiameter)
      : super(productId, circleDiameter);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      margin: const EdgeInsets.symmetric(
          vertical: kPhotoPadding + 9, horizontal: kPhotoPadding + 7),
      width: circleDiameter,
      height: circleDiameter,
      child: RawMaterialButton(
        fillColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        onPressed: () => Navigator.of(context).pop(),
        child: Icon(
          size: circleDiameter / 1.35,
          Icons.arrow_back_ios_new_rounded,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}

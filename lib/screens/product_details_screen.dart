import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/providers/cart_notifier.dart';
import 'package:store_app/providers/selected_size.dart';
import 'package:store_app/widgets/currency_and_price_text.dart';
import 'package:store_app/widgets/drop_shadow.dart';
import 'package:store_app/widgets/fab_favorite.dart';
import 'package:store_app/widgets/product_grid_tile.dart';

import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';
import '../widgets/my_cached_network_image.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const route = '/bottom_nav_bar/product_details';
  @override
  Widget build(BuildContext context) {
    late Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    final sizeProvider = Provider.of<SizeNotifier>(context, listen: false);
    sizeProvider.product = product;
    const double circleDiameter = 35;
    TextStyle descriptionTextStyle =
        TextStyle(color: Theme.of(context).colorScheme.secondary);
    TextStyle titleTextStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(fontWeight: FontWeight.w700, fontSize: 22);
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: Align(
              alignment: Alignment.topLeft,
              child: _FABBack(product, circleDiameter)),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Hero(
                      tag: product.id,
                      child: Stack(children: [
                        _ImageContainer(product: product),
                        Align(
                            alignment: Alignment.topRight,
                            child: FABFavorite(product, circleDiameter)),
                        // Align(
                        //     alignment: Alignment.topLeft,
                        //     child: _FABBack(product.id, 35)),
                      ]),
                    ),
                    const SizedBox(
                      height: 47,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 5, right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  product.title,
                                  style: titleTextStyle,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              CurrencyAndPriceText(
                                price: product.price == product.price.toInt()
                                    ? product.price.toInt()
                                    : product.price,
                                sizeMultiplicationFactor: 1.32,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          product.description == null ||
                                  product.description == ''
                              ? Container()
                              : Column(children: [
                                  Text(
                                    product.description!,
                                    style: descriptionTextStyle,
                                  ),
                                ]),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Choose Size",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizesRow(
                            product: product,
                          ),
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

class SizesRow extends StatelessWidget {
  const SizesRow({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: product.sizeQuantity.keys
            .map((String size) => _SizeCard(size))
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
  late final CartNotifier cartProvider = context.read<CartNotifier>();
  late String dropdownValue = "1";
  @override
  Widget build(BuildContext context) {
    final SizeNotifier sizeProvider = Provider.of<SizeNotifier>(context);
    String currentlySelectedSize = sizeProvider.currentlySelectedSize;
    return Row(
      children: [
        DropDown(
            List<int>.generate(
                widget.product.sizeQuantity[currentlySelectedSize]!,
                (i) => i + 1), (value) {
          dropdownValue = value;
        }, widget.product),
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
                    widget.product,
                    int.parse(dropdownValue),
                    sizeProvider.currentlySelectedSize);
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
}

class DropDown extends StatefulWidget {
  const DropDown(this.quantityList, this.onQuantityChanged, this.product);
  final List quantityList;
  final Function(String) onQuantityChanged;
  final Product product;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  late String dropdownValue = "1";
  late final CartNotifier cartProvider = context.read<CartNotifier>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = getQuantityIfCartItemExists() ?? "1";
  }

  @override
  void didUpdateWidget(covariant DropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the widget has been rebuilt due to a change in the parent widget (due to size change)
    if (widget != oldWidget) {
      dropdownValue = getQuantityIfCartItemExists() ?? "1";
    }
  }

  String? getQuantityIfCartItemExists() {
    for (CartItem cartItem in cartProvider.items) {
      if (cartItem.size ==
              Provider.of<SizeNotifier>(context, listen: false)
                  .currentlySelectedSize &&
          cartItem.product.id == widget.product.id) {
        return cartItem.quantity.toString();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
            return widget.quantityList
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
          items: widget.quantityList
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
          style: const TextStyle(color: kTextLightColor),
          onChanged: (value) {
            setState(() {
              widget.onQuantityChanged(value!);
              dropdownValue = value;
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
    return DropShadowImage(
        offset: const Offset(0, 10),
        scale: 1.1,
        blurRadius: 30,
        borderRadius: 35,
        cachedNetworkImage: MyCachedNetworkImage(product.imageUrl!));
  }
}

class _SizeCard extends StatelessWidget {
  final String size;

  const _SizeCard(this.size);

  @override
  Widget build(BuildContext context) {
    final sizeProvider = Provider.of<SizeNotifier>(context);
    final isSelected = sizeProvider.currentlySelectedSize == size;
    final colorScheme = Theme.of(context).colorScheme;
    TextStyle sizeTextStyle = TextStyle(
        color: isSelected
            ? kTextLightColor
            : Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 17);
    return GestureDetector(
      onTap: () {
        sizeProvider.currentlySelectedSize = size;
      },
      child: SizedBox(
        height: 45,
        width: 55,
        child: Card(
          color: isSelected ? kActiveColor : colorScheme.primary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            // side: const BorderSide(
            //     color: Color.fromARGB(255, 191, 189, 189), width: 0.8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(size, style: sizeTextStyle),
          ),
        ),
      ),
    );
  }
}

class _FABBack extends FABFavorite {
  _FABBack(Product product, double circleDiameter)
      : super(product, circleDiameter);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      margin: const EdgeInsets.symmetric(
          vertical: kPhotoPadding + 24, horizontal: kPhotoPadding + 18),
      width: circleDiameter,
      height: circleDiameter,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
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

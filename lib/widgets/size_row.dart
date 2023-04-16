import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/products_notifier.dart';
import 'package:store_app/widgets/size_and_quantity_card.dart';

import '../models/my_theme.dart';

class SizeRow extends StatefulWidget {
  @override
  State<SizeRow> createState() => _SizeRowState();
}

class _SizeRowState extends State<SizeRow> {
  TextStyle sizeTextStyle = const TextStyle(color: kTextLightColor);
  List<SizeAndQuantityCard> get _sizeCards {
    final productsNotifier = Provider.of<ProductsNotifier>(context);
    return productsNotifier.editedProduct.sizeQuantity.entries
        .map(
          (entry) =>
              SizeAndQuantityCard(size: entry.key, quantity: entry.value),
        )
        .toList();
  }

  void addSizeCard(String size, int quantity) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          const SizeAndQuantityCard(isAddCard: true),
          ..._sizeCards
        ]));
  }
}

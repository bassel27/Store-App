import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/constants.dart';
import '../providers/products_notifier.dart';

class PriceTextFormField extends StatelessWidget {
  const PriceTextFormField(this.priceFocusNode, this.descriptionFocusNode);
  final FocusNode priceFocusNode;
  final FocusNode descriptionFocusNode;
  @override
  Widget build(BuildContext context) {
    var productsProvider =
        Provider.of<ProductsNotifier>(context, listen: false);
    return TextFormField(
      initialValue: productsProvider.editedProduct.price == 0
          ? null
          : productsProvider.editedProduct.price.toStringAsFixed(2),
      decoration: const InputDecoration(
          labelText: "Price", errorStyle: kErrorTextStyle),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: priceFocusNode,
      validator: _validatePrice,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(descriptionFocusNode);
      },
      onSaved: (value) {
        if (value != null) {
          productsProvider.editedProduct = productsProvider.editedProduct
              .copyWith(price: double.parse(value));
        }
      },
    );
  }

  /// Returns null if ented price is valid. Else, it returns an error
  /// message that is displayed on the TextFormField.
  String? _validatePrice(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    if (double.tryParse(value) == null) {
      return "Please enter a valid number";
    }
    if (double.parse(value) <= 0) {
      return "Please enter a number greater than zero";
    }
    return null;
  }
}

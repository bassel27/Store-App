import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/constants.dart';
import '../providers/products_notifier.dart';

class DescriptionTextFormField extends StatelessWidget {
  final FocusNode _descriptionFocusNode;
  const DescriptionTextFormField(this._descriptionFocusNode);
  @override
  Widget build(BuildContext context) {
    var productsProvider =
        Provider.of<ProductsNotifier>(context, listen: false);
    return TextFormField(
        initialValue: productsProvider.editedProduct.description,
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            labelText: "Description"),
        focusNode: _descriptionFocusNode,
        onSaved: (value) {
          productsProvider.editedProduct =
              productsProvider.editedProduct.copyWith(description: value);
        });
  } 
}

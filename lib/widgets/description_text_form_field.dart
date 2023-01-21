import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/constants.dart';
import '../providers/products_notifier.dart';

class DescriptionTextFormField extends StatelessWidget {
  final FocusNode _descriptionFocusNode;
  const DescriptionTextFormField(this._descriptionFocusNode);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            labelText: "Description", errorStyle: kErrorTextStyle),
        focusNode: _descriptionFocusNode,
        onSaved: (value) {
          Provider.of<ProductsNotifier>(context, listen: false)
              .editedProductDescription = value;
        });
  }
}

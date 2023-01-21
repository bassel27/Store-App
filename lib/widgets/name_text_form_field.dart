import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/products_notifier.dart';

import '../models/constants.dart';

class NameTextFormField extends StatelessWidget {
  const NameTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Name",
        errorStyle: kErrorTextStyle,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide a value';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        if (value != null) {
          Provider.of<ProductsNotifier>(context, listen: false)
              .editedProductName = value;
        }
      },
    );
  }
}

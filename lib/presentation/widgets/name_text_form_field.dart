import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/presentation/notifiers/products_notifier.dart';


class NameTextFormField extends StatelessWidget {
  const NameTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    var productsProvider =
        Provider.of<ProductsNotifier>(context, listen: false);

    return TextFormField(
      initialValue: productsProvider.editedProduct.title,
      decoration: const InputDecoration(
        labelText: "Name",
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
          productsProvider.editedProduct =
              productsProvider.editedProduct.copyWith(title: value);
        }
      },
    );
  }
}

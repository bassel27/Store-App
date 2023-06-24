import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifiers/products_notifier.dart';



class DescriptionTextFormField extends StatelessWidget {
  final FocusNode _descriptionFocusNode;
  DescriptionTextFormField(this._descriptionFocusNode);
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var productsProvider =
        Provider.of<ProductsNotifier>(context, listen: false);
    return TextFormField(
        initialValue: productsProvider.editedProduct.description,
        scrollController: _scrollController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(labelText: "Description"),
        focusNode: _descriptionFocusNode,
        onSaved: (value) {
          productsProvider.editedProduct =
              productsProvider.editedProduct.copyWith(description: value);
        });
  }
}

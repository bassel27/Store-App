import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/constants.dart';
import '../models/validate_image_mixin.dart';
import '../providers/products_notifier.dart';

class ImageUrlTextFormField extends StatelessWidget with ValidateImageUrl {
  const ImageUrlTextFormField(
      {required this.imageUrlFocusNode,
      required this.imageUrlController,
      required this.saveFormFunction});
  final FocusNode imageUrlFocusNode;
  final TextEditingController imageUrlController;
  final Function saveFormFunction;

  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsNotifier>(context);

    return TextFormField(
      validator: validateImageUrl,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.url,
      decoration: const InputDecoration(
          labelText: "Image URL", errorStyle: kErrorTextStyle),
      controller: imageUrlController,
      focusNode: imageUrlFocusNode,
      onFieldSubmitted: (_) {
        saveFormFunction();
      }, // when the done key is pressed
      onSaved: (value) {
        // setState(() {});
        if (value != null) {
          productsProvider.editedProduct = productsProvider.editedProduct.copyWith(imageUrl: value);
        }
      },
    );
  }
}

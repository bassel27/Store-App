import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/validate_image_mixin.dart';

import '../models/constants.dart';
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
          Provider.of<ProductsNotifier>(context, listen: false)
              .editedProductImageUrl = value;
        }
      },
    );
  }
}

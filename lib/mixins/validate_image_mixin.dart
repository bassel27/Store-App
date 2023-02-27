//TODO: imageUrl validator check if link is valid and chekck if link contains iamge.

import 'package:flutter/material.dart';

mixin ValidateImageUrl {
  /// Returns null if entered image URL is valid. Else, it returns an error
  /// message that is displayed on the TextFormField.
  String? validateImageUrl(String? imageUrlTextFormFieldValue, Image? image) {
    if (image == null &&
        (imageUrlTextFormFieldValue == null ||
            imageUrlTextFormFieldValue.isEmpty)) {
      return 'Image is missing.';
    } else if (imageUrlTextFormFieldValue != null &&
        !imageUrlTextFormFieldValue.startsWith('http') &&
        !imageUrlTextFormFieldValue.startsWith('https')) {
      return 'Provide a valid image url.';
    }
    // else if (!value.endsWith('.png') &&
    //     !value.endsWith('.jpg') &&
    //     !value.endsWith('.jpeg')) {
    //   return 'Please provide a valid image url.';
    // }
    return null;
  }
}

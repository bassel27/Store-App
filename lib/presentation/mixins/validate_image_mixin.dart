//TODO: imageUrl validator check if link is valid and chekck if link contains iamge.

import 'package:flutter/material.dart';

mixin ValidateImageUrl {
  /// Returns null if entered image URL is valid or if there's nothign written. If image url is invalid, it returns an error
  /// message that is displayed on the TextFormField.
  String? validateImageUrl(String? imageUrlTextFormFieldValue, Image? image) {
    bool isSomethingWritten = imageUrlTextFormFieldValue != null &&
        imageUrlTextFormFieldValue.isNotEmpty;
    // if (
    //     // image == null &&
    //     !isSomethingWritten) {
    //   return 'Image url is missing.';
    // } else
    if (isSomethingWritten &&
        !imageUrlTextFormFieldValue.startsWith('http') &&
        !imageUrlTextFormFieldValue.startsWith('https')) {
      return 'Provide a valid image url.';
    }
    return null;
  }
}

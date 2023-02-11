//TODO: imageUrl validator check if link is valid and chekck if link contains iamge.
mixin ValidateImageUrl {
  /// Returns null if entered image URL is valid. Else, it returns an error
  /// message that is displayed on the TextFormField.
  String? validateImageUrl(value) {
    if (value == null || value.isEmpty) {
      return 'Please provide a valid image url.';
    } else if (!value.startsWith('http') && !value.startsWith('https')) {
      return 'Please provide a valid image url.';
    }
    // else if (!value.endsWith('.png') &&
    //     !value.endsWith('.jpg') &&
    //     !value.endsWith('.jpeg')) {
    //   return 'Please provide a valid image url.';
    // }
    return null;
  }
}

import 'package:flutter/material.dart';

import '../models/product.dart';

//TODO: use something else except double for monetary values
class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const route = "/settings/edit_products_screen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  /// Controller for accessing the input to add the image preview  before
  /// submission.
  final _imageUrlController = TextEditingController();

  /// Key for accessing all the validators and savers of all TextFormFields.
  final _formKey = GlobalKey<FormState>();

  /// The new product.
  Product _editedProduct =
      Product(id: '', name: '', description: '', price: 0, imageUrl: '');

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  onSaved: _onNameSaved,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  validator: _validatePrice,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: _onPriceSaved,
                ),
                TextFormField(
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(labelText: "Description"),
                  focusNode: _descriptionFocusNode,
                  onSaved: _onDescriptionSaved,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    imageContainer(),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: _validateImageUrl,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        decoration:
                            const InputDecoration(labelText: "Image URL"),
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) =>
                            _saveForm(), // when the done key is pressed
                        onSaved: _onImageUrlSaved,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container imageContainer() {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey),
      ),
      child: _imageUrlController.text.isEmpty
          ? const FittedBox(child: Text("Enter a URL"))
          : Image.network(_imageUrlController.text, fit: BoxFit.cover),
    );
  }

  /// Sets state to update image container content when image url formfield
  ///  goes out of focus and also when the done key is pressed (because
  /// formfield goes out of focus).
  void _updateImageUrl() {
    // if the form field became out of focus and (it's empty or has valid url)
    if (!_imageUrlFocusNode.hasFocus &&
        (_imageUrlController.text.isEmpty ||
            _validateImageUrl(_imageUrlController.text) == null)) {
      setState(() {});
    }
  }

  /// Runs all the validators and all the savers when the save button is pressed
  /// or the keyboard's done button is pressed in the image URL text field.
  void _saveForm() {
    final areInputsValid =
        _formKey.currentState!.validate(); // this runs all the validators

    if (areInputsValid) {
      _formKey.currentState!.save(); // this runs all the savers
    }
  }

  //validators
  /// Returns null if entered name is valid. Else, it returns an error
  /// message that is displayed on the TextFormField.
  String? _validateName(value) {
    if (value == null || value.isEmpty) {
      return 'Please provide a value';
    }
    return null;
  }

  /// Returns null if ented price is valid. Else, it returns an error
  /// message that is displayed on the TextFormField.
  String? _validatePrice(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    if (double.tryParse(value) == null) {
      return "Please enter a valid number";
    }
    if (double.parse(value) <= 0) {
      return "Please enter a number greater than zero";
    }
    return null;
  }

  /// Returns null if entered image URL is valid. Else, it returns an error
  /// message that is displayed on the TextFormField.
  String? _validateImageUrl(value) {
    if (value == null || value.isEmpty) {
      return 'Please provide a valid image url.';
    } else if (!value.startsWith('http') && !value.startsWith('https')) {
      return 'Please provide a valid image url.';
    } else if (!value.endsWith('.png') &&
        !value.endsWith('.jpg') &&
        !value.endsWith('.jpeg')) {
      return 'Please provide a valid image url.';
    }
    return null;
  }

  // saver
  void _onNameSaved(value) {
    if (value != null) {
      _editedProduct = Product(
          id: _editedProduct.id,
          name: value,
          description: _editedProduct.description,
          price: _editedProduct.price,
          imageUrl: _editedProduct.imageUrl,
          isFavorite: _editedProduct.isFavorite);
    }
  }

  void _onPriceSaved(value) {
    if (value != null) {
      _editedProduct = Product(
          id: _editedProduct.id,
          name: _editedProduct.name,
          description: _editedProduct.description,
          price: double.parse(value),
          imageUrl: _editedProduct.imageUrl,
          isFavorite: _editedProduct.isFavorite);
    }
  }

  void _onDescriptionSaved(value) {
    _editedProduct = Product(
        id: _editedProduct.id,
        name: _editedProduct.name,
        description: value ?? '',
        price: _editedProduct.price,
        imageUrl: _editedProduct.imageUrl,
        isFavorite: _editedProduct.isFavorite);
  }

  void _onImageUrlSaved(value) {
    setState(() {});
    if (value != null) {
      _editedProduct = Product(
          id: _editedProduct.id,
          name: _editedProduct.name,
          description: _editedProduct.description,
          price: _editedProduct.price,
          imageUrl: value,
          isFavorite: _editedProduct.isFavorite);
    }
  }
}

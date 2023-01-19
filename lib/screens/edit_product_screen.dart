import 'package:flutter/material.dart';

import '../models/product.dart';

/// The new product.
Product _editedProduct =
    Product(id: '', name: '', description: '', price: 0, imageUrl: '');

/// Key for accessing all the validators and savers of all TextFormFields.
final _formKey = GlobalKey<FormState>();

class EditProductScreen extends StatefulWidget {
  static const route = "/settings/edit_products_screen";
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  /// Controller for accessing the input to add the image preview  before
  /// submission.
  final _imageUrlController = TextEditingController();

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  void initState() {
    super.initState();
    widget._imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    widget._priceFocusNode.dispose();
    widget._descriptionFocusNode.dispose();
    widget._imageUrlFocusNode.dispose();
    widget._imageUrlFocusNode.removeListener(_updateImageUrl);
    widget._imageUrlController.dispose();
  }

  void _onSaveButtonPressed() {
    setState(
        () {}); // to display image after pressing save (imageurl textfield doesn't go out of foxus on save press)
    _saveForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _onSaveButtonPressed,
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
                const NameTextFormField(),
                PriceTextField(
                    widget._priceFocusNode, widget._descriptionFocusNode),
                DescriptionTextField(widget._descriptionFocusNode),
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
                      child: ImageUrlTextFormField(widget._imageUrlFocusNode,
                          widget._imageUrlController),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  onPressed: _onSaveButtonPressed,
                  child: const Text("Save"),
                ),
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
      child: widget._imageUrlController.text.isEmpty
          ? const FittedBox(child: Text("Enter a URL"))
          : Image.network(widget._imageUrlController.text, fit: BoxFit.cover),
    );
  }

  /// Sets state to update image container content when image url formfield
  ///  goes out of focus and also when the done key is pressed (because
  /// formfield goes out of focus).
  void _updateImageUrl() {
    // if the form field became out of focus and (it's empty or has valid url)
    if (!widget._imageUrlFocusNode.hasFocus &&
        (widget._imageUrlController.text.isEmpty ||
            _validateImageUrl(widget._imageUrlController.text) == null)) {
      setState(() {});
    }
  }
}

const TextStyle kErrorTextStyle =
    TextStyle(fontWeight: FontWeight.w400, color: Colors.red);

class NameTextFormField extends StatelessWidget {
  const NameTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Name",
        errorStyle: kErrorTextStyle,
      ),
      validator: _validateName,
      textInputAction: TextInputAction.next,
      onSaved: _onNameSaved,
    );
  }

  /// Returns null if entered name is valid. Else, it returns an error
  /// message that is displayed on the TextFormField.
  String? _validateName(value) {
    if (value == null || value.isEmpty) {
      return 'Please provide a value';
    }
    return null;
  }

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
}

class PriceTextField extends StatelessWidget {
  const PriceTextField(this.priceFocusNode, this.descriptionFocusNode);
  final FocusNode priceFocusNode;
  final FocusNode descriptionFocusNode;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: "Price", errorStyle: kErrorTextStyle),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: priceFocusNode,
      validator: _validatePrice,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(descriptionFocusNode);
      },
      onSaved: _onPriceSaved,
    );
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
}

class DescriptionTextField extends StatelessWidget {
  final FocusNode _descriptionFocusNode;
  const DescriptionTextField(this._descriptionFocusNode);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
          labelText: "Description", errorStyle: kErrorTextStyle),
      focusNode: _descriptionFocusNode,
      onSaved: _onDescriptionSaved,
    );
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
}

class ImageUrlTextFormField extends StatelessWidget {
  const ImageUrlTextFormField(
      this._imageUrlFocusNode, this._imageUrlController);
  final FocusNode _imageUrlFocusNode;
  final _imageUrlController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: _validateImageUrl,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.url,
      decoration: const InputDecoration(
          labelText: "Image URL", errorStyle: kErrorTextStyle),
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (_) => _saveForm(), // when the done key is pressed
      onSaved: _onImageUrlSaved,
    );
  }

  void _onImageUrlSaved(value) {
    // setState(() {});
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

/// Runs all the validators and all the savers when the save button is pressed
/// or the keyboard's done button is pressed in the image URL text field.
void _saveForm() {
  final areInputsValid =
      _formKey.currentState!.validate(); // this runs all the validators

  if (areInputsValid) {
    _formKey.currentState!.save(); // this runs all the savers
  }
  print(
      "name: ${_editedProduct.name}, price: ${_editedProduct.price} and url: ${_editedProduct.imageUrl}");
}

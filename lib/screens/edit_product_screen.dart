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
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Product _editedProduct =
      Product(id: '', name: '', description: '', price: 0, imageUrl: '');
  // the image needs a controller because we want to access to the input before the user submits to add the preview
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
    _saveForm();
  }

  String? _validateName(value) {
    if (value == null || value.isEmpty) {
      return 'Please provide a value';
    }
    return null;
  }

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

  void _updateImageUrl() {
    String urlEntryText = _imageUrlController.text;
    if (!_imageUrlFocusNode.hasFocus) {
      // if ((!urlEntryText.startsWith('http') &&
      //         !urlEntryText.startsWith('https')) ||
      //     (!urlEntryText.endsWith('.png') && !urlEntryText.endsWith('.jpg')) ||
      //     (!urlEntryText.endsWith('.jpeg'))) {
      //   return;
      // }
      setState(() {});
    }
  }

  void _saveForm() {
    final areInputsValid =
        _formKey.currentState!.validate(); // this runs all the validators
    if (areInputsValid) {
      _formKey.currentState!.save();
    }
  }
}

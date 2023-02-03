import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/validate_image_mixin.dart';
import '../providers/products_notifier.dart';
import '../widgets/description_text_form_field.dart';
import '../widgets/image_url_text_form_field.dart';
import '../widgets/name_text_form_field.dart';
import '../widgets/price_text_form_field.dart';

class EditProductScreen extends StatefulWidget {
  static const route = "/settings/edit_products_screen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen>
    with ValidateImageUrl {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  bool _firstTime = true;

  /// Key for accessing all the validators and savers of all TextFormFields.
  final _formKey = GlobalKey<FormState>();

  /// Controller to access the input display image preview before submission.
  late final _imageUrlController = TextEditingController(
      text: Provider.of<ProductsNotifier>(context, listen: false)
          .editedProduct
          .imageUrl);
  final mySizedBox = const SizedBox(
    height: 25,
  );
  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    if (_firstTime) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        Provider.of<ProductsNotifier>(context, listen: false).editedProduct =
            ModalRoute.of(context)?.settings.arguments as Product;
      }
      _firstTime = false;
    }
    super.didChangeDependencies();
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
                PriceTextFormField(_priceFocusNode, _descriptionFocusNode),
                DescriptionTextFormField(_descriptionFocusNode),
                mySizedBox,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _imageContainer(),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ImageUrlTextFormField(
                        imageUrlFocusNode: _imageUrlFocusNode,
                        imageUrlController: _imageUrlController,
                        saveFormFunction: _saveForm,
                      ),
                    ),
                  ],
                ),
                mySizedBox,
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

  Container _imageContainer() {
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
            validateImageUrl(_imageUrlController.text) == null)) {
      setState(() {});
    }
  }

  void _onSaveButtonPressed() {
    setState(
        () {}); // to display image after pressing save (imageurl textfield doesn't go out of foxus on save press)
    _saveForm();
  }

  /// Runs all the validators and all the savers when the save button is pressed
  /// or the keyboard's done button is pressed in the image URL text field.
  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      dismissKeyboard();
      // this runs all the validators
      _formKey.currentState!.save(); // this runs all the savers
      var productProvider =
          Provider.of<ProductsNotifier>(context, listen: false);
      var editedProduct = productProvider.editedProduct;
      try {
        if (editedProduct.id.isEmpty) {
          await addNewProduct(productProvider, editedProduct, context);
        } else {
          await productProvider.updateProduct(editedProduct.id, editedProduct);
        }
        if (mounted) {
          Navigator.of(context).pop(); // pop EditProductScreen
        }
      } catch (e) {
        // do nothing and leave error dialog and leave edit screen
      }
    }
  }

  void dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Future<void> addNewProduct(ProductsNotifier productProvider,
      Product editedProduct, BuildContext context) async {
    await productProvider.addProduct(editedProduct);
  }
}

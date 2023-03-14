import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/product_image_notifier.dart';
import 'package:uuid/uuid.dart';

import '../controllers/error_handler.dart';
import '../mixins/validate_image_mixin.dart';
import '../models/product/product.dart';
import '../providers/products_notifier.dart';
import '../widgets/description_text_form_field.dart';
import '../widgets/name_text_form_field.dart';
import '../widgets/price_text_form_field.dart';

class EditProductScreen extends StatefulWidget {
  static const route = "/bottom_nav_bar/my_account/edit_products_screen";
  final Product? product;
  const EditProductScreen(this.product);
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen>
    with ValidateImageUrl {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  bool _firstTime = true;
  Color imageContainerTextColor = Colors.black;

  /// Key for accessing all the validators and savers of all TextFormFields.
  final _formKey = GlobalKey<FormState>();

  /// Controller to access the input display image preview before submission.

  final mySizedBox = const SizedBox(
    height: 25,
  );

  @override
  void didChangeDependencies() {
    if (_firstTime) {
      if (widget.product != null) {
        ProductsNotifier productsProvider =
            Provider.of<ProductsNotifier>(context, listen: false);
        productsProvider.editedProduct = widget.product!;
        Future.delayed(Duration.zero).then((value) {
          ProductImageNotifier imageProvider =
              Provider.of<ProductImageNotifier>(context, listen: false);
          imageProvider.image = Image.network(
              productsProvider.editedProduct.imageUrl,
              fit: BoxFit.cover);
        });
        _firstTime = false;
      }
      super.didChangeDependencies();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Image? image =
        Provider.of<ProductImageNotifier>(context, listen: false).image;
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
          child: ListView(
            children: [
              const NameTextFormField(),
              PriceTextFormField(_priceFocusNode, _descriptionFocusNode),
              DescriptionTextFormField(_descriptionFocusNode),
              mySizedBox,
              _ImageRow(_saveForm, imageContainerTextColor),
              mySizedBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: _saveForm,
                child: Text(
                  "Save",
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateFormFieldsAndImage() {
    if (context.read<ProductImageNotifier>().image == null) {
      // invalid
      setState(() {
        imageContainerTextColor = Theme.of(context).colorScheme.error;
      });
      _formKey.currentState!.validate();
      return false;
    } // valid
    if (_formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  /// Runs all the validators and all the savers when the save button is pressed
  /// or the keyboard's done button is pressed in the image URL text field.
  void _saveForm() async {
    if (validateFormFieldsAndImage()) {
      dismissKeyboard();
      // this runs all the validators
      _formKey.currentState!.save(); // this runs all the savers
      var productsProvider =
          Provider.of<ProductsNotifier>(context, listen: false);
      var editedProduct = productsProvider.editedProduct;
      try {
        if (editedProduct.id.isEmpty) {
          await productsProvider
              .addProduct(editedProduct.copyWith(id: const Uuid().v4()));
        } else {
          await productsProvider.updateProduct(editedProduct);
        }
        if (mounted) {
          Navigator.of(context).pop(); // pop EditProductScreen
        }
      } catch (e) {
        ErrorHandler().handleException(e);
      }
    }
  }

  void dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

class _ImageRow extends StatelessWidget {
  const _ImageRow(this.onSaveButtonPressed, this.imageContainerTextColor);
  final VoidCallback onSaveButtonPressed;

  final Color imageContainerTextColor;
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: _ImageContainer(imageContainerTextColor)),
      const SizedBox(
        width: 10,
      ),
      Column(mainAxisSize: MainAxisSize.min, children: [
        _PhotoInputFromDeviceColumn(
            Provider.of<ProductImageNotifier>(context, listen: false)),
      ])
    ]);
  }
}

class _PhotoInputFromDeviceColumn extends StatelessWidget {
  const _PhotoInputFromDeviceColumn(this.imageProvider);

  final ProductImageNotifier imageProvider;

  /// Checks if image file isn't null first.
  void modifyImageContainer(
    XFile? imageFile,
  ) {
    if (imageFile != null) {
      imageProvider.image = Image.file(File(imageFile.path));
    }
  }

  Future<void> _takePicture() async {
    final imageFile =
        await ImagePicker() // TODO: config for ios check doccumentaoin
            .pickImage(source: ImageSource.camera, maxWidth: 600); // resolution
    modifyImageContainer(imageFile);
  }

  Future<void> _chooseFromGallery() async {
    final XFile? imageFile =
        await ImagePicker() // TODO: config for ios check doccumentaoin
            .pickImage(
                source: ImageSource.gallery, maxWidth: 600); // resolution
    modifyImageContainer(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        const Text("Or"),
        _PhotoTextButton(
            _chooseFromGallery, "Choose from Gallery", Icons.photo_album),
        const SizedBox(
          width: 10,
        ),
        const Text("Or"),
        _PhotoTextButton(_takePicture, "Take a photo", Icons.camera_alt)
      ],
    );
  }
}

class _PhotoTextButton extends StatelessWidget {
  const _PhotoTextButton(this.onPressed, this.text, this.iconData);
  final VoidCallback onPressed;
  final String text;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(),
      icon: Icon(
        iconData,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: onPressed,
      label: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class _ImageContainer extends StatelessWidget {
  const _ImageContainer(this.imageContainerTextColor);
  final Color imageContainerTextColor;
  @override
  Widget build(BuildContext context) {
    Image? image = Provider.of<ProductImageNotifier>(context).image;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey),
      ),
      child: image ??
          Text(
            "Take a photo\nor\nChoose from gallery",
            textAlign: TextAlign.center,
            style: TextStyle(color: imageContainerTextColor),
          ),
    );
  }
}

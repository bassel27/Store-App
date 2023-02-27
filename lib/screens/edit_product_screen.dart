import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/product_image.dart';
import 'package:uuid/uuid.dart';

import '../controllers/error_handler.dart';
import '../mixins/validate_image_mixin.dart';
import '../models/product/product.dart';
import '../providers/products_notifier.dart';
import '../widgets/description_text_form_field.dart';
import '../widgets/image_url_text_form_field.dart';
import '../widgets/name_text_form_field.dart';
import '../widgets/price_text_form_field.dart';

class EditProductScreen extends StatefulWidget {
  static const route = "/settings/edit_products_screen";
  final Product? product;
  const EditProductScreen(this.product);
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
      if (widget.product != null) {
        Provider.of<ProductsNotifier>(context, listen: false).editedProduct =
            widget.product!;
      }
      if (_imageUrlController.text.isNotEmpty) {
        Future.delayed(Duration.zero).then((value) =>
            Provider.of<ProductImageNotifier>(context, listen: false).image =
                Image.network(_imageUrlController.text, fit: BoxFit.cover));
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
    Image? image =
        Provider.of<ProductImageNotifier>(context, listen: false).image;
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
          child: ListView(
            children: [
              const NameTextFormField(),
              PriceTextFormField(_priceFocusNode, _descriptionFocusNode),
              DescriptionTextFormField(_descriptionFocusNode),
              mySizedBox,
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: _imageContainer(context)),
                const SizedBox(
                  width: 10,
                ),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    width: 210,
                    child: ImageUrlTextFormField(
                        imageUrlFocusNode: _imageUrlFocusNode,
                        imageUrlController: _imageUrlController,
                        saveFormFunction: _saveForm,
                        image: image),
                  ),
                  _PhotoInputFromDeviceColumn(
                      _imageUrlController,
                      Provider.of<ProductImageNotifier>(context,
                          listen: false)),
                ])
              ]),
              mySizedBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: _onSaveButtonPressed,
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

  Container _imageContainer(BuildContext context) {
    // TODO: try passing image as a parameter and see if it will work
    Image? image = Provider.of<ProductImageNotifier>(context).image;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey),
      ),
      child: image ??
          const Text("Enter a URL\nor take a photo\nor choose from gallery"),
    );
  }

  /// Sets state to update image container content when image url formfield
  ///  goes out of focus and also when the done key is pressed (because
  /// formfield goes out of focus).
  void _updateImageUrl() {
    ProductImageNotifier? imageProvider =
        Provider.of<ProductImageNotifier>(context, listen: false);
    // if the form field became out of focus and (it's empty or has valid url)
    if (!_imageUrlFocusNode.hasFocus &&
        (_imageUrlController.text.isEmpty ||
            validateImageUrl(_imageUrlController.text, imageProvider.image) ==
                null)) {
      imageProvider.image =
          Image.network(_imageUrlController.text, fit: BoxFit.cover);
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
      var productsProvider =
          Provider.of<ProductsNotifier>(context, listen: false);
      var editedProduct = productsProvider.editedProduct;
      try {
        if (editedProduct.id.isEmpty) {
          await addNewProduct(productsProvider,
              editedProduct.copyWith(id: const Uuid().v4()), context);
        } else {
          await productsProvider.updateProduct(editedProduct);
        }
        if (mounted) {
          Navigator.of(context).pop(); // pop EditProductScreen
        }
      } catch (e) {
        ErrorHandler().handleError(e);
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

class _PhotoInputFromDeviceColumn extends StatelessWidget {
  const _PhotoInputFromDeviceColumn(
      this.imageUrlController, this.imageProvider);
  final imageUrlController;
  final ProductImageNotifier imageProvider;
  void modifyImage(imageFile) {
    if (imageFile != null) {
      imageProvider.image = Image.file(File(imageFile.path));
      imageUrlController.clear();
    }
  }

  Future<void> _takePicture() async {
    final imageFile =
        await ImagePicker() // TODO: config for ios check doccumentaoin
            .pickImage(source: ImageSource.camera, maxWidth: 600); // resolution
    modifyImage(imageFile);
  }

  Future<void> _chooseFromGallery() async {
    final imageFile =
        await ImagePicker() // TODO: config for ios check doccumentaoin
            .pickImage(
                source: ImageSource.gallery, maxWidth: 600); // resolution
    modifyImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        const Text("Or"),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(),
          icon: Icon(
            Icons.photo_album,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: _chooseFromGallery,
          label: Text(
            "Choose from Gallery",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text("Or"),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(),
          icon: Icon(
            Icons.camera_alt,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: _takePicture,
          label: Text(
            "Take a photo",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ],
    );
  }
}

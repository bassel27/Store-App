import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/product_image_notifier.dart';
import 'package:store_app/widgets/my_cached_network_image.dart';
import 'package:uuid/uuid.dart';

import '../controllers/excpetion_handler.dart';
import '../mixins/validate_image_mixin.dart';
import '../models/my_theme.dart';
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
          Provider.of<ProductImageNotifier>(context, listen: false).image =
              MyCachedNetworkImage(productsProvider.editedProduct.imageUrl!);
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
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(child: _ImageContainer(imageContainerTextColor)),
                const SizedBox(
                  width: 10,
                ),
                _PhotoInputFromDeviceColumn(
                    Provider.of<ProductImageNotifier>(context, listen: false)),
              ]),
              const SizedBox(
                height: 12,
              ),
              _SizeRow(),
              const SizedBox(
                height: 12,
              ),
              saveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton saveButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
      onPressed: _saveForm,
      child: Text(
        "Save",
        style: Theme.of(context).textTheme.button,
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
      Product editedProduct = productsProvider.editedProduct;

      try {
        if (editedProduct.id.isEmpty) {
          File imageFile =
              Provider.of<ProductImageNotifier>(context, listen: false)
                  .imageFile!;
          await productsProvider.addProduct(
              editedProduct.copyWith(id: const Uuid().v4()), imageFile);
        } else {
          File? imageFile =
              Provider.of<ProductImageNotifier>(context, listen: false)
                  .imageFile;
          await productsProvider.updateProduct(editedProduct, imageFile);
        }
        if (mounted) {
          Navigator.of(context).pop(); // pop EditProductScreen
        }
      } catch (e) {
        ExceptionHandler().handleException(e);
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

class _PhotoInputFromDeviceColumn extends StatelessWidget {
  const _PhotoInputFromDeviceColumn(this.imageProvider);

  final ProductImageNotifier imageProvider;

  /// Checks if image file isn't null first.
  void modifyImageContainer(
    XFile? imageXFile,
  ) {
    if (imageXFile != null) {
      File imageFile = File(imageXFile.path);
      imageProvider.imageFile = imageFile;
      imageProvider.image = Image.file(imageFile);
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PhotoTextButton(_takePicture, "Take a photo", Icons.camera_alt),
          const Text("Or"),
          _PhotoTextButton(
              _chooseFromGallery, "Choose from Gallery", Icons.photo_album),
        ],
      ),
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
    Color buttonColor = Theme.of(context).colorScheme.tertiary;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.4, color: buttonColor),
      ),
      icon: Icon(
        iconData,
        color: buttonColor,
      ),
      onPressed: onPressed,
      label: Text(
        text,
        style: TextStyle(color: buttonColor),
      ),
    );
  }
}

class _ImageContainer extends StatelessWidget {
  const _ImageContainer(this.imageContainerTextColor);
  final Color imageContainerTextColor;
  @override
  Widget build(BuildContext context) {
    dynamic image = Provider.of<ProductImageNotifier>(context).image;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey),
      ),
      child: image ??
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Text(
              "Take a photo\nor\nChoose from gallery",
              textAlign: TextAlign.center,
              style: TextStyle(color: imageContainerTextColor),
            ),
          ),
    );
  }
}

class _SizeRow extends StatefulWidget {
  @override
  State<_SizeRow> createState() => _SizeRowState();
}

class _SizeRowState extends State<_SizeRow> {
  final List<_SizeCard> _sizeCards = [];
  TextStyle sizeTextStyle = const TextStyle(color: kTextLightColor);
  void addSizeCard(String size, int quantity) {
    setState(() {
      _sizeCards
          .add(_SizeCard(size: size, quantity: quantity, onAdd: addSizeCard));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _SizeCard(onAdd: addSizeCard, isAddCard: true),
          ..._sizeCards
        ]));
  }
}

class _SizeCard extends StatefulWidget {
  final String? size;
  final int? quantity;
  final bool isAddCard;
  final Function(String, int) onAdd;
  const _SizeCard(
      {this.size, this.quantity, required this.onAdd, this.isAddCard = false});

  @override
  State<_SizeCard> createState() => _SizeCardState();
}

class _SizeCardState extends State<_SizeCard> {
  TextStyle sizeTextStyle = const TextStyle(
      color: kTextLightColor, fontWeight: FontWeight.bold, fontSize: 17);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSizeQuantityDialog(widget.quantity, widget.size, context);
      },
      child: SizedBox(
        height: 90,
        width: 70,
        child: Card(
          color: Theme.of(context).colorScheme.tertiary,
          elevation: 4,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.isAddCard == true
                  ? [
                      const Icon(
                        Icons.add,
                        color: kTextLightColor,
                      )
                    ]
                  : [
                      Text(
                        widget.size!,
                        style: sizeTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(widget.quantity.toString(), style: sizeTextStyle)
                    ]),
        ),
      ),
    );
  }

  void _showSizeQuantityDialog(
      int? inputQuantity, String? inputSize, BuildContext context) async {
    final theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
    );

    String size = inputSize ?? '';
    int quantity = inputQuantity ?? 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter Size and Quantity',
                    style: TextStyle(
                      color: kTextDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Size',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kTextDarkColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.colorScheme.secondary),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                    ),
                    onSaved: (newValue) {
                      if (newValue != null) size = newValue;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Quantity',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kTextDarkColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.colorScheme.secondary),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onSaved: (newValue) {
                      if (newValue != null) quantity = int.parse(newValue);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            color: kTextDarkColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          final form = formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            widget.onAdd(size, quantity);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

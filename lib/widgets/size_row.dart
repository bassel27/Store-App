import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/products_notifier.dart';

import '../models/my_theme.dart';

class SizeRow extends StatefulWidget {
  @override
  State<SizeRow> createState() => _SizeRowState();
}

class _SizeRowState extends State<SizeRow> {
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
        height: 70,
        width: 50,
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
                    AutoSizeText(
                      widget.size!,
                      maxLines: 1,
                      style: sizeTextStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    AutoSizeText(
                      widget.quantity.toString(),
                      maxLines: 2,
                      style: sizeTextStyle,
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  void _showSizeQuantityDialog(
      int? inputQuantity, String? inputSize, BuildContext context) async {
    String? size = inputSize;
    int? quantity = inputQuantity;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                  _SizeTextFormField(
                    initialSize: size,
                    onSaved: (String? newValue) {
                      if (newValue != null) size = newValue.toUpperCase();
                    },
                  ),
                  const SizedBox(height: 16),
                  QuantityTextFormField(
                    initialQuantity: quantity,
                    onSaved: (newValue) {
                      if (newValue != null) quantity = int.parse(newValue);
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CancelButton(),
                      const SizedBox(width: 8),
                      OkButton(
                        onPressed: () {
                          final form = formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            widget.onAdd(size!, quantity!);
                            final editedProduct = Provider.of<ProductsNotifier>(
                                    context,
                                    listen: false)
                                .editedProduct;
                            final newProduct = editedProduct.copyWith(
                              sizeQuantity: {
                                ...editedProduct.sizeQuantity,
                                size!: quantity!,
                              },
                            );
                            Provider.of<ProductsNotifier>(context,
                                    listen: false)
                                .editedProduct = newProduct;
                            Navigator.of(context).pop();
                          }
                        },
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

class _SizeTextFormField extends StatelessWidget {
  const _SizeTextFormField({
    Key? key,
    required this.onSaved,
    this.initialSize,
  }) : super(key: key);
  final Function(String?) onSaved;
  final String? initialSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialSize,
      decoration: InputDecoration(
        hintText: 'Size',
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: kTextDarkColor),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
      ),
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide a value';
        }
        return null;
      },
    );
  }
}

class QuantityTextFormField extends StatelessWidget {
  const QuantityTextFormField(
      {Key? key, required this.onSaved, this.initialQuantity})
      : super(key: key);
  final onSaved;
  final int? initialQuantity;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialQuantity == null ? null : initialQuantity.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Quantity',
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: kTextDarkColor),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
      ),
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide a value';
        }
        return null;
      },
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'CANCEL',
        style: TextStyle(
          color: kTextDarkColor,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class OkButton extends StatelessWidget {
  const OkButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: onPressed,
      child: const Text(
        'OK',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

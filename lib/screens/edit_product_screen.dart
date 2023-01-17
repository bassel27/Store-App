import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({super.key});
  static const route = "/settings/edit_products_screen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            child: SingleChildScrollView(
                child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Name"),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Price"),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
            ),
            TextFormField(
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(labelText: "Description"),
              textInputAction: TextInputAction.done,
              focusNode: _descriptionFocusNode,
            ),
          ],
        ))),
      ),
    );
  }
}
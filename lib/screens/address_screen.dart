import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  static const route = '/bottom_nav_bar/address_screen';
  final GlobalKey<FormState> formKey = GlobalKey();
  late final widgets = [
    _MyTextFormField(formKey: formKey, labelText: 'First Name'),
    _MyTextFormField(formKey: formKey, labelText: 'Last Name'),
    _MyTextFormField(
      formKey: formKey,
      labelText: 'Address',
      maxLines: 2,
    ),
    _MyTextFormField(formKey: formKey, labelText: 'City'),
    _MyTextFormField(formKey: formKey, labelText: 'Mobile Number'),
    _MyTextFormField(
      formKey: formKey,
      labelText: 'Additional Information',
      maxLines: 3,
    ),
    ElevatedButton(onPressed: () {}, child: const Text("Save"))
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Address")),
      body: Form(
        key: formKey,
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: widgets.length,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            return widgets[index];
          },
        ),
      ),
    );
  }
}

String? validateString(value) {
  if (value == null || value.isEmpty) {
    return 'Please provide a value';
  }
  return null;
}

class _MyTextFormField extends StatelessWidget {
  const _MyTextFormField(
      {required this.formKey, required this.labelText, this.maxLines = 1});
  final GlobalKey<FormState> formKey;
  final String labelText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validateString,
      textInputAction: TextInputAction.next,
      onSaved: (value) {},
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}

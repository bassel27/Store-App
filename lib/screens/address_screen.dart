import 'package:flutter/material.dart';
import 'package:store_app/models/address/address.dart';
import 'package:store_app/widgets/wide_elevated_button.dart';

class AddressScreen extends StatelessWidget {
  static const route = '/bottom_nav_bar/address_screen';
  final GlobalKey<FormState> formKey = GlobalKey();
  Address editedAddress = const Address(
      firstName: '', lastName: '', address: '', city: '', mobileNumber: '');
  late final widgets = [
    _MyTextFormField(
      formKey: formKey,
      labelText: 'First Name',
      onSaved: (value) {
        editedAddress = editedAddress.copyWith(firstName: value!);
      },
    ),
    _MyTextFormField(
      formKey: formKey,
      labelText: 'Last Name',
      onSaved: (value) {
        editedAddress = editedAddress.copyWith(lastName: value!);
      },
    ),
    _MyTextFormField(
      formKey: formKey,
      labelText: 'Address',
      maxLines: 2,
      onSaved: (value) {
        editedAddress = editedAddress.copyWith(address: value!);
      },
    ),
    _MyTextFormField(
      formKey: formKey,
      labelText: 'City',
      onSaved: (value) {
        editedAddress = editedAddress.copyWith(city: value!);
      },
    ),
    _MyTextFormField(
      formKey: formKey,
      labelText: 'Mobile Number',
      textInputType: TextInputType.number,
      onSaved: (value) {
        editedAddress = editedAddress.copyWith(mobileNumber: value!);
      },
    ),
    _MyTextFormField(
      formKey: formKey,
      labelText: 'Additional Information',
      maxLines: 2 ,
      onSaved: (value) {
        editedAddress = editedAddress.copyWith(additionalInformation: value!);
      },
    ),
    const SizedBox(
      height: 10,
    ),
    WideElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          }
        },
        child: "Save"),
    const SizedBox(
      height: 10,
    ),
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
      {required this.formKey,
      required this.labelText,
      required this.onSaved,
      this.maxLines = 1,
      this.textInputType});
  final GlobalKey<FormState> formKey;
  final String labelText;
  final int maxLines;
  final TextInputType? textInputType;
  final Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validateString,
      textInputAction: TextInputAction.next,
      onSaved: onSaved,
      keyboardType: textInputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}

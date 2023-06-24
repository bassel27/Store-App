import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/presentation/notifiers/user_notifier.dart';

import '../../data/models/address/address.dart';
import '../widgets/wide_elevated_button.dart';


class AddressScreen extends StatelessWidget {
  static const route = '/bottom_nav_bar/address_screen';
  final GlobalKey<FormState> formKey = GlobalKey();
  Address editedAddress = const Address(
      firstName: '', lastName: '', address: '', city: '', mobileNumber: '');

  @override
  Widget build(BuildContext context) {
    Address? userCurrentAddress =
        Provider.of<UserNotifier>(context, listen: false).currentUser!.address;

    if (userCurrentAddress != null) {
      editedAddress = userCurrentAddress;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Address")),
      body: Form(
        key: formKey,
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: widgets(context).length,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            return widgets(context)[index];
          },
        ),
      ),
    );
  }

  List<Widget> widgets(BuildContext context) {
    return [
      _MyTextFormField(
        formKey: formKey,
        labelText: 'First Name',
        initialValue: editedAddress.firstName,
        onSaved: (value) {
          editedAddress = editedAddress.copyWith(firstName: value!);
        },
      ),
      _MyTextFormField(
        formKey: formKey,
        labelText: 'Last Name',
        initialValue: editedAddress.lastName,
        onSaved: (value) {
          editedAddress = editedAddress.copyWith(lastName: value!);
        },
      ),
      _MyTextFormField(
        formKey: formKey,
        labelText: 'Address',
        initialValue: editedAddress.address,
        maxLines: 2,
        onSaved: (value) {
          editedAddress = editedAddress.copyWith(address: value!);
        },
      ),
      _MyTextFormField(
        formKey: formKey,
        labelText: 'City',
        initialValue: editedAddress.city,
        onSaved: (value) {
          editedAddress = editedAddress.copyWith(city: value!);
        },
      ),
      _MyTextFormField(
        formKey: formKey,
        labelText: 'Mobile Number',
        initialValue: editedAddress.mobileNumber,
        textInputType: TextInputType.number,
        onSaved: (value) {
          editedAddress = editedAddress.copyWith(mobileNumber: value!);
        },
      ),
      _MyTextFormField(
        formKey: formKey,
        labelText: 'Additional Information',
        initialValue: editedAddress.additionalInformation,
        maxLines: 2,
        isValidateString: false,
        onSaved: (value) {
          editedAddress = editedAddress.copyWith(additionalInformation: value!);
        },
      ),
      const SizedBox(
        height: 10,
      ),
      WideElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              await Provider.of<UserNotifier>(context, listen: false)
                  .postAddress(editedAddress);
              Navigator.pop(context);
            }
          },
          child: "Save"),
      const SizedBox(
        height: 10,
      ),
    ];
  }
}

String? validateString(value) {
  if (value == null || value.isEmpty) {
    return 'Please provide a value';
  }
  return null;
}

class _MyTextFormField extends StatelessWidget {
  _MyTextFormField(
      {required this.formKey,
      required this.labelText,
      required this.onSaved,
      this.initialValue,
      this.maxLines = 1,
      this.isValidateString = true,
      this.textInputType});
  final GlobalKey<FormState> formKey;
  final String labelText;
  final bool isValidateString;
  String? initialValue;
  final int maxLines;
  final TextInputType? textInputType;
  final Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    if (initialValue == '') {
      initialValue = null;
    }
    return TextFormField(
      initialValue: initialValue,
      validator: isValidateString ? validateString : null,
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

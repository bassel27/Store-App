import 'package:flutter/material.dart';
import 'package:store_app/models/my_theme.dart';

mixin MyInputDecoration {
  InputDecoration inputDecoration(
      BuildContext context, String hintText, IconData iconData) {
    var myBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary, width: 0.8),
    );
    return InputDecoration(
      // labelStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
      // labelText: hintText,
      hintStyle: const TextStyle(color: kTextDarkColor),
      hintText: hintText,
      filled: true,
      fillColor: Theme.of(context).colorScheme.background,
      border: myBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary, width: 2.7),
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          iconData,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

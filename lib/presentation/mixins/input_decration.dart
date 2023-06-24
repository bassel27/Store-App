import 'package:flutter/material.dart';

mixin MyInputDecoration {
  InputDecoration authenticationInputDecoration(
      {required BuildContext context,
      required String hintText,
      Icon? icon,
      isDense = false,
      OutlineInputBorder? outlineInputBorder,
      isBorderSideOn = false}) {
    var defaultOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 2.7),
    );
    var myBorder = outlineInputBorder ?? defaultOutlineInputBorder;
    return InputDecoration(
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      hintText: hintText,
      isDense: isDense,
      contentPadding: const EdgeInsets.all(15),
      filled: true,
      fillColor: Theme.of(context).colorScheme.background,
      border: myBorder,
      focusedBorder: outlineInputBorder ?? defaultOutlineInputBorder,
      prefixIcon: icon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(right: 10),
              child: icon,
            ),
    );
  }
}

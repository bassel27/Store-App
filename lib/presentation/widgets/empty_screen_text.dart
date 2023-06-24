import 'package:flutter/material.dart';

class EmptyScreenText extends StatelessWidget {
  final String _text;
  const EmptyScreenText(this._text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Center(
          child: Text(
        _text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 30,
        ),
      )),
    );
  }
}

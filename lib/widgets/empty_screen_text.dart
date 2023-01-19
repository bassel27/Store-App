import 'package:flutter/material.dart';

class EmptyScreenText extends StatelessWidget {
  final String _text;
  const EmptyScreenText(this._text);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      _text,
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
    ));
  }
}

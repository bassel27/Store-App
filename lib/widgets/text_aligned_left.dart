import 'package:flutter/material.dart';

class TextAlignedLeft extends StatelessWidget {
  final String text;
  const TextAlignedLeft(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}

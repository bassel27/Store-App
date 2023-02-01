import 'package:flutter/material.dart';

class ErrorScaffoldBody extends StatelessWidget {
  const ErrorScaffoldBody(this.exception);
  final Exception exception;
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
          "Oops! Something went wrong. Check your internet connection and try again."),
    );
  }
}

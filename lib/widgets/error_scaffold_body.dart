import 'package:flutter/material.dart';
import '../models/constants.dart';

class ErrorScaffoldBody extends StatelessWidget {
  const ErrorScaffoldBody(this.exception);
  final Exception exception;
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(kErrorMessage),
    );
  }
}

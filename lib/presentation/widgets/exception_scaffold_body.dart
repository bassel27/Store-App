import 'package:flutter/material.dart';
import 'package:store_app/data/models/constants.dart';



class ExceptionScaffoldBody extends StatelessWidget {
  const ExceptionScaffoldBody(this.exception);
  final Exception exception;
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(kErrorMessage),
    );
  }
}

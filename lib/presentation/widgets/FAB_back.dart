import 'package:flutter/material.dart';

import '../../data/models/constants.dart';



class FABBack extends StatelessWidget {
  const FABBack(this.circleDiameter);
  final double circleDiameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      margin: const EdgeInsets.symmetric(
          vertical: kPhotoPadding + 24, horizontal: kPhotoPadding + 18),
      width: circleDiameter,
      height: circleDiameter,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        onPressed: () => Navigator.of(context).pop(),
        child: Icon(
          size: circleDiameter / 1.35,
          Icons.arrow_back_ios_new_rounded,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}

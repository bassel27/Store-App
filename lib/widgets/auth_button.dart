import 'package:flutter/material.dart';

class WideElevatedButton extends StatelessWidget {
  final String child;
  final VoidCallback? onPressed;
  const WideElevatedButton({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ))),
          child: Text(child)),
    );
  }
}

import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;
  const AuthButton({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
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

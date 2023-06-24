import 'package:flutter/material.dart';

class WideElevatedButton extends StatelessWidget {
  final String child;
  final VoidCallback? onPressed;
  const WideElevatedButton({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        height: 40,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
            child: Text(child)),
      ),
    );
  }
}

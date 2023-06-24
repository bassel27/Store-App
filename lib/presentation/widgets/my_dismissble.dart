import 'package:flutter/material.dart';

class MyDismissible extends StatelessWidget {
  const MyDismissible({
    Key? key,
    required String valueKeyId,
    required void Function(DismissDirection) onDismissed,
    required Widget child,
  })  : _valueKeyId = valueKeyId,
        _onDismissed = onDismissed,
        _child = child,
        super(key: key);

  final String _valueKeyId;
  final void Function(DismissDirection) _onDismissed;
  final Widget _child;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: _onDismissed,
      key: ValueKey(_valueKeyId),
      background: Container(
        padding: const EdgeInsets.only(right: 15),
        color: Theme.of(context).errorColor,
        child: const Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete, color: Colors.white)),
      ),
      direction: DismissDirection.endToStart,
      child: _child,
    );
  }
}

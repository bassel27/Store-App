import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/my_theme.dart';

class MessageBubble extends StatelessWidget {
  final String message;

  const MessageBubble(this.message);

  @override
  Widget build(BuildContext context) {
    return Bubble(
      color: const Color.fromARGB(255, 253, 184, 80),
      margin: const BubbleEdges.symmetric(vertical: 1.5, horizontal: 6),
      elevation: 1,
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      child: Text(
        message,
        style: const TextStyle(
            color: kTextLightColor, fontWeight: FontWeight.w400),
      ),
    );
  }
}

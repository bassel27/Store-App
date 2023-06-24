import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/my_theme.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  @override
  final Key? key;
  const MessageBubble(this.message, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Bubble(
      color: isMe
          ? const Color.fromARGB(255, 253, 184, 80)
          : Theme.of(context).colorScheme.primary,
      margin: const BubbleEdges.symmetric(vertical: 1.5, horizontal: 6),
      elevation: 1,
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
      child: Text(
        message,
        style: TextStyle(
            color: isMe ? kTextLightColor : kTextDarkColor,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:store_app/mixins/input_decration.dart';

import '../controllers/chat_controller.dart';
import '../mixins/try_catch_firebase.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField({super.key});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField>
    with MyInputDecoration, TryCatchFirebaseWrapper {
  String _enteredMessage = "";
  void _sendMessage() async {
    // TODO: add loading and delivered on chat
    FocusScope.of(context).unfocus();
    await wrapInTryCatch(
        () => ChatController().sendMessage(_enteredMessage), true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            decoration:
                inputDecoration(context, 'Send a message...', Icons.message),
            onChanged: (value) => setState(() {
              _enteredMessage = value;
            }),
          )),
          IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}

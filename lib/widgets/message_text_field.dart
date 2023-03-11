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
    await wrapInTryCatch(() async {
      await ChatController().sendMessage(_enteredMessage);
      _messageController.clear();
    }, true);
  }

  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.0,
          ),
        ),
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messageController,
            decoration: inputDecoration(
                outlineInputBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 2.7),
                ),
                context: context,
                hintText: 'Send a message...',
                icon: null,
                isDense: true),
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

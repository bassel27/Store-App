import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/widgets/exception_scaffold_body.dart';
import 'package:store_app/widgets/message_bubble.dart';
import 'package:store_app/widgets/message_text_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const route = '/bottom_nav_bar/my_account/chat_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Support")),
      body: Column(
        children: const [
          Expanded(child: _Messages()),
          MessageTextField(),
        ],
      ),
    );
  }
}

class _Messages extends StatelessWidget {
  const _Messages();
  final String kMessagesCollectionAddress = '/chats/$kMyChatId/messages';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(kMessagesCollectionAddress)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return ExceptionScaffoldBody(snapshot.error as Exception);
            } else if (snapshot.hasData) {
              var docs = snapshot.data!.docs;
              return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) =>
                      MessageBubble(docs[index]['text'], BubbleNip.rightTop));
            }
            return const Center(child: Text("No Messages"));
          default:
            return Center(child: Text(snapshot.connectionState.toString()));
        }
      },
    );
  }
}

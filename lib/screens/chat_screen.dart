import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static const route = '/settings/chat_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('/chats/cNvZUC4up60TY1ODLYV9/messages')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // else if (snapshot.connectionState == ConnectionState.done &&
          //     snapshot.data != null) {
          var docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) => Text(
                    docs[index]['text'],
                  ));
          // }
          // this builder fuunction is executed whenever the stream gives us a new value
        },
      ),
    );
  }
}

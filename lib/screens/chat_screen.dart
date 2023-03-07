import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/widgets/exception_scaffold_body.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static const route = '/bottom_nav_bar/my_account/chat_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Support")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(kMessagesCollectionAddress)
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
                    itemCount: docs.length,
                    itemBuilder: (context, index) => Text(
                          docs[index]['text'],
                        ));
              }
              return const Center(child: Text("No Messages"));
            default:
              return Center(child: Text(snapshot.connectionState.toString()));
          }
        },
      ),
    );
  }
}

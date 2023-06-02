import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/constants.dart';
import 'package:store_app/widgets/empty_screen_text.dart';
import 'package:store_app/widgets/exception_scaffold_body.dart';
import 'package:store_app/widgets/message_bubble.dart';
import 'package:store_app/widgets/message_text_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const route = '/bottom_nav_bar/my_account/chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPushNotifications();
  }

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
              print(snapshot.error.toString());
              return ExceptionScaffoldBody(snapshot.error as Exception);
            } else if (snapshot.hasData) {
              var docs = snapshot.data!.docs;
              if (docs.isNotEmpty) {
                return ListView.builder(
                    reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) => MessageBubble(
                        docs[index]['text'],
                        docs[index]['userId'] ==
                            FirebaseAuth.instance.currentUser!.uid,
                        key: ValueKey(docs[index].id)));
              } else {
                return const EmptyScreenText("No Messages");
              }
            }
            return const Center(child: Text("No Messages"));
          default:
            return Center(child: Text(snapshot.connectionState.toString()));
        }
      },
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message :-): ${message.data}");
  //Here you can do what you want with the message :-)
}

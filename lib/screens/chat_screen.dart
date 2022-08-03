import 'package:flutter/material.dart';
import 'package:flashchat_returns/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


late final _firestore = FirebaseFirestore.instance;  late User loggedInUser;



class ChatScreen extends StatefulWidget {
  static const String id = 'chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

// void getMessages() async {
//   final messages = await _firestore.collection('messages').get();
//   // Calling getDocuments() is deprecated in favor of get() > per https://firebase.flutter.dev/docs/migration#firestore
//   // class uses "messages" instead of "databaseMessages"
//   print(messages);
//
// }
  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        // "documents" deprecated to "docs"
        print(message.data());
        // above was print(message.data); BUT Getting a snapshots data via the data getter is now done via the data() method. per https://firebase.flutter.dev/docs/migration#firestore
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);

              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
              MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messagesBubbles = [];
          for (var message in messages) {
            // final messageData = message.data();
            final messageText = (message.data() as Map)['text'];
            final messageSender = (message.data() as Map)['sender'];
            final currentuser = loggedInUser.email;


            final messageBubble =
            MessageBubble(messageSender, messageText,currentuser == messageSender);
            messagesBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messagesBubbles,
            ),
          );
        } else {
          print("Error");
          return Column(
            children: [],
          );
        }
      },
      stream: _firestore.collection("messages").snapshots(),
    );
  }
}





class MessageBubble extends StatelessWidget {
  MessageBubble(this.sender, this.text,this.isMe);
  late final String sender;
  late final String text;
  final  bool isMe;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),),
          Material(
              borderRadius: isMe?BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)):BorderRadius.only( bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30),topRight: Radius.circular(30)),
              elevation: 6,
              color: isMe?Colors.lightBlueAccent: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$text',
                  style: TextStyle(
                    fontSize: 20,
                    color: isMe?Colors.white:Colors.black,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

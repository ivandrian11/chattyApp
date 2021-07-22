import 'package:chatty_app/common/config.dart';
import 'package:chatty_app/common/size_config.dart';
import 'package:chatty_app/services/connectivity_check.dart';
import 'package:chatty_app/ui/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  static String routeName = "chat";
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _fs = FirebaseFirestore.instance;
  User _loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        _loggedInUser = user;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = AppBar(
      backgroundColor: blueColor,
      title: Text('Chat Room'),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              setState(() {});
              if (!ConnectivityCheck.isDisconnect) {
                _auth.signOut();
                Navigator.of(context)
                    .pushReplacementNamed(WelcomePage.routeName);
              }
            }),
      ],
    );

    Widget middleWidget(Widget child) {
      return Expanded(
        child: Center(
          child: child,
        ),
      );
    }

    Widget messagesStream = StreamBuilder<QuerySnapshot>(
        stream: _fs.collection('messages').orderBy('sendTime').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data.docs.reversed;
            List<MessageBubble> messageBubbles = [];
            for (var message in messages) {
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final messageTimeSent = message.data()['sendTime'].toDate();
              final messageBubble = MessageBubble(
                text: messageText,
                sender: messageSender,
                isMe: _loggedInUser.email == messageSender,
                sendTime: messageTimeSent,
              );

              messageBubbles.add(messageBubble);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                children: messageBubbles,
              ),
            );
          } else if (snapshot.hasError) {
            return middleWidget(
                Text('Data has not been loaded. Please restart your app.'));
          } else {
            return middleWidget(CircularProgressIndicator());
          }
        });

    Widget chatField = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (SizeConfig.safeBlockHorizontal * 1.1).roundToDouble(),
        vertical: (SizeConfig.safeBlockVertical * 0.65).roundToDouble(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              maxLines: 4,
              minLines: 1,
              controller: _messageTextController,
              decoration: textFieldDecoration(
                hintText: 'Type message.....',
                color: blackColor,
              ).copyWith(
                hintStyle: TextStyle(
                    color: Color(0xff999999),
                    fontSize:
                        (SizeConfig.safeBlockHorizontal * 4.4).roundToDouble(),
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          SizedBox(
              width: (SizeConfig.safeBlockHorizontal * 1.1).roundToDouble()),
          CircleAvatar(
            radius: (SizeConfig.safeBlockVertical * 4.2).roundToDouble(),
            backgroundColor: blueColor,
            child: RotatedBox(
              quarterTurns: 1,
              child: IconButton(
                icon: Icon(
                  Icons.navigation,
                  color: Colors.white,
                  size: (SizeConfig.safeBlockVertical * 4.2).roundToDouble(),
                ),
                onPressed: () {
                  if (_messageTextController.text.isNotEmpty) {
                    _fs.collection('messages').add({
                      'text': _messageTextController.text,
                      'sender': _loggedInUser.email,
                      'sendTime': DateTime.now(),
                    });
                    _messageTextController.clear();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: appBar,
      body: ConnectivityCheck(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            messagesStream,
            chatField,
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final DateTime sendTime;

  MessageBubble({
    @required this.isMe,
    @required this.sender,
    @required this.text,
    @required this.sendTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: (SizeConfig.safeBlockVertical * 1.6).roundToDouble(),
        bottom: (SizeConfig.safeBlockVertical * 1.6).roundToDouble(),
        right: isMe
            ? (SizeConfig.safeBlockHorizontal * 2.78).roundToDouble()
            : (SizeConfig.screenWidth * 0.2),
        left: isMe
            ? (SizeConfig.screenWidth * 0.2)
            : (SizeConfig.safeBlockHorizontal * 2.78).roundToDouble(),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '${sender.split('@')[0]}',
            style: TextStyle(
              color: blackColor,
              fontSize: (SizeConfig.safeBlockHorizontal * 3.89).roundToDouble(),
            ),
          ),
          Material(
            elevation: 5,
            color: isMe ? Colors.white : Color(0xffEAEFF3),
            borderRadius: isMe
                ? BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    (SizeConfig.safeBlockHorizontal * 3.3).roundToDouble(),
                vertical: (SizeConfig.safeBlockVertical * 1.95).roundToDouble(),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    text,
                    style: TextStyle(
                      fontSize: (SizeConfig.safeBlockHorizontal * 4.4)
                          .roundToDouble(),
                    ),
                    textAlign: isMe ? TextAlign.right : TextAlign.left,
                  ),
                  SizedBox(
                    height:
                        (SizeConfig.safeBlockVertical * 0.65).roundToDouble(),
                  ),
                  Text(
                    '${sendTime.hour}:${sendTime.minute}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: (SizeConfig.safeBlockHorizontal * 3.3)
                          .roundToDouble(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

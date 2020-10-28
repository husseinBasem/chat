import 'package:flutter/material.dart';
import 'package:chat/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/bloc/Chat_bloc/chat_bloc.dart';

import '../Component/image.dart';

//User  loggedInUser;

class ChatScreen extends StatefulWidget {
  ChatScreen({this.name, this.roomId, this.image, this.token, this.email});

  final String name;
  final String roomId;
  final String image;
  final String token;
  final String email;

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

//  final _auth = FirebaseAuth.instance;
  String _message;
  ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc();
    chatBloc.add(ChatWithEvent(token: widget.token));
  }

  @override
  void dispose() {
    super.dispose();
    chatBloc.closeScreen();
    chatBloc.close();
  }

//  void getCurrentUser() {
//
//    try {
//      final user = _auth.currentUser;
//      if (user != null) {
//        loggedInUser = user;
//      }
//    }catch(e){
//      print(e);
//    }
//  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(),
      child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
        chatBloc = BlocProvider.of<ChatBloc>(context);

        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: ImageWidget(changePhoto: false,networkImage: widget.image,height: 40.0,width: 40.0,),
              ),
            ],
            title: Text(widget.name),
            centerTitle: true,
            backgroundColor: Colors.lightBlueAccent,

          ),


          body: SafeArea(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),

                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[

                              Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: chatBloc.block == true ? null : Container(
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection("ChatRoom").doc(widget.roomId).collection("chats")
                                          .orderBy("timestamp", descending: true).snapshots(),

                                      builder: (context, snapshot) {
                                        chatBloc.add(BlockEvent(roomId: widget.roomId, email: widget.email));

                                        if (chatBloc.numberOFMessagesAreNotSeen == null) {
                                          chatBloc.add(GetValueEvent(email: widget.email, roomId: widget.roomId));
                                          return Container();

                                        } else if (snapshot.hasData && chatBloc.numberOFMessagesAreNotSeen != null) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              reverse: true,
                                              itemCount: snapshot.data.docs.length,
                                              itemBuilder: (context, index) {

                                                final messages = snapshot.data.docs[index];
                                                final isMe = FirebaseAuth.instance.currentUser.email == messages.data()['sentBy'];
                                                return Padding(
                                                  padding: EdgeInsets.only(bottom: 5.0, right: 3.0, left: 3.0),
                                                  child: Column(
                                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end
                                                        : CrossAxisAlignment.start,
                                                    children: <Widget>[

                                                      Material(
                                                        borderRadius: isMe ? BorderRadius.only(
                                                          topLeft: Radius.circular(30.0),
                                                          bottomLeft: Radius.circular(30.0),
                                                          topRight: Radius.circular(20.0),)
                                                          : BorderRadius.only(
                                                          bottomRight: Radius.circular(30.0),
                                                          topRight: Radius.circular(30.0),
                                                          topLeft: Radius.circular(20.0),),
                                                      color: isMe ? Colors.lightBlueAccent : Colors.black54,
                                                        child: Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                                          child: Container(
                                                              constraints: BoxConstraints(
                                                                  maxWidth: MediaQuery.of(context).size.width / 2),

                                                              child: Row(
                                                                textDirection: TextDirection.ltr,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: <Widget>[
                                                                  Flexible(
                                                                    child: Text(messages.data()['message'],

                                                                      textAlign: TextAlign.left,
                                                                      style: TextStyle(color: Colors.white,
                                                                          fontSize: 15.0),
                                                                    ),
                                                                  ),

                                                                  Padding(padding: EdgeInsets.only(top: 7.0),
                                                                    child: Text('   ${messages.data()['timestamp'].substring(10, 16)} ',
                                                                      textAlign: TextAlign.left,
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 12.0,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  Padding(padding: EdgeInsets.only(top: 7.0),
                                                                      child: isMe ?
                                                                      StreamBuilder(
                                                                        stream: FirebaseFirestore.instance.collection("ChatRoom").doc(widget.roomId).snapshots(),
                                                                        builder: (context, snapshot) {

                                                                          if (snapshot.hasData) {
                                                                            return Container(
                                                                              child: index >= snapshot.data.data()['messagesArenotSeen']
                                                                                  ? Icon(Icons.done_all, color: Colors.white, size: 15.0,)
                                                                                  : Icon(Icons.done, color: Colors.white, size: 15.0,),);
                                                                          } else
                                                                            return Container();
                                                                          },
                                                                      )
                                                                          : null),
                                                                ],
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });

                                        } else {
                                          return Container();
                                        }
                                      }),
                                ),
                              ),
                              Container(
                                decoration: kMessageContainerDecoration,
                                child: chatBloc.block == false
                                    ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                    Expanded(
                                      child: TextField(
                                        controller: messageTextController,
                                        onChanged: (value) {
                                          _message = value;
                                          chatBloc.add(MessagePlayLoadEvent(
                                              token: widget.token,
                                              message: _message));
                                          },
                                        decoration: kMessageTextFileDecoration,
                                      ),

                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        messageTextController.clear();
                                        chatBloc.add(AddConversationMessageEvent(
                                            roomId: widget.roomId,
                                            message: _message,
                                            email: widget.email));
                                        },

                                      child: Text('Send',
                                        style: kSendButtonTextStyle,
                                      ),

                                    ),
                                  ],
                                )
                                    : Container(
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  color: Colors.red,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'You Got Blocked From ${widget.name}',
                                        style: TextStyle(height: 2.0, fontSize: 17.0, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    );
                  })),
        );
      }),
    );
  }
}

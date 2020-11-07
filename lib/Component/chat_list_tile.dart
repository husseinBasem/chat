import 'package:chat/Transition/slide_right_route.dart';
import 'package:chat/bloc/chat_list_bloc/chat_list_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chat_id.dart';
import '../Screens/chat_screen.dart';
import 'image.dart';

class ChatsListTile extends StatelessWidget {
  ChatsListTile(
      {this.receiverEmail,
      this.lastMessage,
      this.messagesUnSeen,
      this.showIcon,
      this.chatListBloc});

  final String receiverEmail, lastMessage;
  final int messagesUnSeen;
  final bool showIcon;
  final CreateChatId  createChatId = CreateChatId();
  final ChatListBloc chatListBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('Email', isEqualTo: receiverEmail)
          .snapshots(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {





              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.black45,
                    child: ListTile(
                      title: Text(
                        snapshot.data.docs[index].data()['Name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        lastMessage,
                        style: TextStyle(color: Colors.white70),
                      ),
                      leading: CircleAvatar(
                        radius: 25.0,
                        child: ImageWidget(
                          width: 65.0,
                          changePhoto: false,
                          firstLetter: snapshot.data.docs[index].data()['Name'][0],
                          networkImage: snapshot.data.docs[index].data()['userImage'],


                        ),
                      ),


                      trailing: messagesUnSeen == 0 || showIcon == true
                          ? null
                          : CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.redAccent,
                              child: Text(
                                messagesUnSeen.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                      onTap: () {

                        chatListBloc.add(SwitchToChatScreenEvent(
                            mobileToken:snapshot.data.docs[index].data()['mobileToken'] ,
                            roomId:createChatId.getChatID(
                                FirebaseAuth.instance.currentUser.email,
                                snapshot.data.docs[index]
                                    .data()['Email']) ,email:snapshot.data.docs[index]
                                            .data()['Email'] ));


                        chatListBloc.startConversion(
                            email:snapshot.data.docs[index].data()['Email'],
                            roomId: createChatId.getChatID(FirebaseAuth.instance.currentUser.email, snapshot.data.docs[index].data()['Email']),
                            mobileToken: snapshot.data.docs[index].data()['mobileToken']);

                        Navigator.push(context, SlideRightRoute(page: ChatScreen(
                            name: snapshot.data.docs[index]
                                .data()['Name'],
                            roomId: createChatId.getChatID(
                                FirebaseAuth.instance.currentUser.email,
                                snapshot.data.docs[index]
                                    .data()['Email']),
                            image: snapshot.data.docs[index].data()['userImage'],
                            token: snapshot.data.docs[index]
                                .data()['mobileToken'],
                            email: snapshot.data.docs[index]
                                .data()['Email']),dx: 1.0,dy: 0.0));





                      },
                    ),
                  ),
                  Divider(
                    height: 0.0,
                    color: Colors.white10,
                    thickness: 1.0,
                    indent: 75.0,
                    endIndent: 10.0,
                  )
                ],
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

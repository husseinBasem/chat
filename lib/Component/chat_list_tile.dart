import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chat_id.dart';
import '../Screens/chat_screen.dart';

class ChatsListTile extends StatelessWidget {
  ChatsListTile(
      {this.receiverEmail,
      this.lastMessage,
      this.messagesUnSeen,
      this.showIcon});

  final String receiverEmail, lastMessage;
  final int messagesUnSeen;
  final bool showIcon;
  CreateChatId createChatId = CreateChatId();

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
              final String imageLink =
                  snapshot.data.docs[index].data()['userImage'];

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
                        backgroundColor: Colors.lightBlueAccent,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.blueAccent,
                              image: imageLink.isEmpty == true
                                  ? DecorationImage(
                                      image: AssetImage(
                                        'images/profile1.jpg',
                                      ),
                                      fit: BoxFit.cover)
                                  : DecorationImage(
                                      image: NetworkImage(imageLink),
                                      fit: BoxFit.cover)),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    name: snapshot.data.docs[index]
                                        .data()['Name'],
                                    roomId: createChatId.getChatID(
                                        FirebaseAuth.instance.currentUser.email,
                                        snapshot.data.docs[index]
                                            .data()['Email']),
                                    image: imageLink,
                                    token: snapshot.data.docs[index]
                                        .data()['mobileToken'],
                                    email: snapshot.data.docs[index]
                                        .data()['Email'])));
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

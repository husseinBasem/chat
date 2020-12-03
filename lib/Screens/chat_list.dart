import 'package:chat/Component/search.dart';
import 'package:chat/Transition/slide_right_route.dart';
import 'package:chat/Screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Component/Custom_list_tile.dart';
import 'package:chat/bloc/chat_list_bloc/chat_list_bloc.dart';

import 'edit_screen.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ChatListBloc bloc;
  var cache;




  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatListBloc>(
      create: (context) => ChatListBloc(),
      child: Scaffold(
        backgroundColor: Colors.white10,
//        resizeToAvoidBottomInset: false,
//        resizeToAvoidBottomPadding: false,

        body: SafeArea(
            child: BlocBuilder<ChatListBloc, ChatListState>(
                builder: (context, state) {
                  bloc = BlocProvider.of<ChatListBloc>(context);
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 30.0,
                        child: Text(
                          'Chats',
                          style: TextStyle(color: Colors.white, fontSize: 25.0,letterSpacing: 2,fontFamily: 'Cookie'),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 7.0),
                        child: SearchWidget(
                          onTap: (){
                          Navigator.push(context,SlideRightRoute(page: SearchScreen(),dx: 1.0,dy: 0.0) );
                          },
                          autofocus: false,
                          readonly: true,
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      StreamBuilder(
                        initialData: cache,
                          stream: FirebaseFirestore.instance
                              .collection('ChatRoom')
                              .orderBy('timeStamp', descending: true)
                              .where('users',
                              arrayContains:
                              FirebaseAuth.instance.currentUser.email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            bool showIcon = false;
                             if (snapshot.hasData) {
                               cache = snapshot.data;
                              return Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
//                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {


                                    if (FirebaseAuth.instance.currentUser.email ==snapshot.data.docs[index].data()['users'][0]) {
                                      showIcon = false;
                                      return CustomListTile(
                                        receiverEmail: snapshot.data.docs[index]
                                            .data()['users'][1],
                                        lastMessage: snapshot.data.docs[index]
                                            .data()['lastMessage'],
                                        messagesUnSeen: snapshot.data.docs[index]
                                            .data()['messagesArenotSeen'],
                                        showIcon: showIcon,
                                        chatListBloc: bloc,
                                        time: snapshot.data.docs[index]
                                            .data()['timeStamp'],
                                      );
                                    } else if (FirebaseAuth.instance.currentUser.email == snapshot.data.docs[index].data()['users'][1]) {
                                      showIcon = true;
                                      return CustomListTile(
                                        receiverEmail: snapshot.data.docs[index]
                                            .data()['users'][0],
                                        lastMessage: snapshot.data.docs[index]
                                            .data()['lastMessage'],
                                        messagesUnSeen: snapshot.data.docs[index]
                                            .data()['messagesArenotSeen'],
                                        showIcon: showIcon,
                                        chatListBloc: bloc,
                                        time: snapshot.data.docs[index]
                                            .data()['timeStamp'],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  );
                })),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, SlideRightRoute(page: Edit(),dx: 1.0,dy: 0.0));
          },
          child: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          backgroundColor: Colors.white12,
        ),
      ),
    );
  }
}



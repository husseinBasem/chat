import 'package:chat/Component/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Component/chat_list_tile.dart';
import '../notifications.dart';
import 'package:chat/bloc/chat_list_bloc/chat_list_bloc.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Notifications notifications;
  ChatListBloc bloc;

  @override
  void initState() {
    super.initState();
    notifications = Notifications();
    notifications.registerNotification();
    notifications.configLocalNotification();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatListBloc(),
      child: Scaffold(
        backgroundColor: Colors.white10,

        body: SafeArea(
            child: BlocListener<ChatListBloc, ChatListState>(
              cubit: bloc,
              listener: (context, state) {
                bloc = BlocProvider.of<ChatListBloc>(context);
                if (state is SwitchToEditState) {
                  Navigator.pushNamed(context, 'edit_screen');
                } else if (state is SwitchToSearchState) {
                  Navigator.pushNamed(context, 'search_screen');
                }},
              child: BlocBuilder<ChatListBloc, ChatListState>(
                  cubit: bloc,
                  builder: (context, state) {
                    bloc = BlocProvider.of<ChatListBloc>(context);
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 25.0,
                            child: Text(
                              'Chats',
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SearchWidget(onTap: (){bloc.add(SwitchToSearchEvent());},),
                          SizedBox(
                            height: 10.0,
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('ChatRoom')
                                  .orderBy('timeStamp', descending: true)
                                  .where('users',
                                  arrayContains:
                                  FirebaseAuth.instance.currentUser.email)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                bool showIcon = false;
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      if (FirebaseAuth.instance.currentUser.email ==snapshot.data.docs[index].data()['users'][0]) {
                                        return ChatsListTile(
                                          receiverEmail: snapshot.data.docs[index]
                                              .data()['users'][1],
                                          lastMessage: snapshot.data.docs[index]
                                              .data()['lastMessage'],
                                          messagesUnSeen: snapshot.data.docs[index]
                                              .data()['messagesArenotSeen'],
                                          showIcon: showIcon,
                                        );
                                      } else if (FirebaseAuth.instance.currentUser.email == snapshot.data.docs[index].data()['users'][1]) {
                                        showIcon = true;
                                        return ChatsListTile(
                                          receiverEmail: snapshot.data.docs[index]
                                              .data()['users'][0],
                                          lastMessage: snapshot.data.docs[index]
                                              .data()['lastMessage'],
                                          messagesUnSeen: snapshot.data.docs[index]
                                              .data()['messagesArenotSeen'],
                                          showIcon: showIcon,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    );
                  }),
            )),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bloc.add(SwitchToEditEvent());
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



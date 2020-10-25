import 'package:chat/Component/search.dart';
import 'package:chat/info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/Search_bloc/search_bloc.dart';
import 'chat_id.dart';
import 'info_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _sendToEmail, _sendToMobileToken;
  CreateChatId createChatId;
  SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    createChatId = CreateChatId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: BlocProvider<SearchBloc>(
        create: (context) => SearchBloc(),
        child: SafeArea(
          child: BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              searchBloc = BlocProvider.of<SearchBloc>(context);
              if (state is SwitchToChatListState) {
                Navigator.pushNamed(context, 'chat_list');
              } else if (state is SwitchToInfoState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Info(
                        email: _sendToEmail,
                        roomId: createChatId.getChatID(
                            FirebaseAuth.instance.currentUser.email,
                            _sendToEmail),
                        mobileToken: _sendToMobileToken,
                      ),
                    ));
              }
            },
            child:
                BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              searchBloc = BlocProvider.of<SearchBloc>(context);

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(child: SearchWidget(
                            onChanged: (value) {
                              searchBloc.add(ChangeUserEvent(search: value));
                            },
                          )),
                          FlatButton(
                            onPressed: () {
                              searchBloc.add(SwitchToChatListEvent());
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('User', isEqualTo: searchBloc.search)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasData) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    _sendToEmail = snapshot
                                        .data.documents[index]
                                        .data()['Email']
                                        .toString();
                                    _sendToMobileToken = snapshot
                                        .data.documents[index]
                                        .data()['mobileToken']
                                        .toString();
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              searchBloc
                                                  .add(SwitchToInfoEvent());
                                            },
                                            title: Text(
                                              snapshot.data.documents[index]
                                                  .data()['Name']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: CircleAvatar(
                                              radius: 20.0,
                                              backgroundColor:
                                                  Colors.lightBlueAccent,
                                              child: Text(
                                                snapshot.data.documents[index]
                                                    .data()['Name']
                                                    .toString()[0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        )
                                      ],
                                    );
                                  },
                                  itemCount: snapshot.data.documents.length,
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ),
                    ]),
              );
            }),
          ),
        ),
      ),
    );
  }
}

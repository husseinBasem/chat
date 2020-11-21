import 'package:chat/Component/image.dart';
import 'package:chat/Component/search.dart';
import 'package:chat/Transition/slide_right_route.dart';
import 'package:chat/Screens/info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/Search_bloc/search_bloc.dart';
import '../chat_id.dart';
import 'info_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _sendToEmail;
  CreateChatId createChatId;
  SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    createChatId = CreateChatId();
  }

  @override
  void dispose() {
    super.dispose();
    searchBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: BlocProvider<SearchBloc>(
        create: (context) => SearchBloc(),
        child: SafeArea(
          child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
            searchBloc = BlocProvider.of<SearchBloc>(context);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SearchWidget(
                              onChanged: (value) {
                                searchBloc.add(ChangeUserEvent(search: value));
                                },
                              autofocus: true,
                              readonly: false,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              },
                            child: Text('Cancel',
                              style: TextStyle(color: Colors.white, fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('users').where('caseSearch', arrayContains:  searchBloc.search ).snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator(),);
                              } else if (snapshot.hasData) {

                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    _sendToEmail = snapshot.data.documents[index].data()['Email'].toString();
                                    if(snapshot.data.documents[index].data()['Uid']!= FirebaseAuth.instance.currentUser.uid){
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
                                              Navigator.push(context, SlideRightRoute(page:Info(
                                                email: _sendToEmail,
                                                roomId: createChatId.getChatID(FirebaseAuth.instance.currentUser.email, _sendToEmail),)
                                                  ,dx: 1.0,dy: 0.0));
                                              },
                                            title: Text(snapshot.data.documents[index].data()['Name'].toString(),
                                              style: TextStyle(color: Colors.white),),
                                            leading: CircleAvatar(
                                              radius: 20.0,
                                              child: ImageWidget(
                                                networkImage: snapshot.data.documents[index].data()['userImage'],
                                                firstLetter: snapshot.data.documents[index].data()['Name'][0],
                                                width: 60.0,
                                                changePhoto: false ,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5.0,)
                                      ],
                                    );
                                    }
                                    else{
                                      return Container();
                                    }
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
    );
  }
}

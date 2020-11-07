import 'package:chat/Component/image.dart';
import 'package:chat/Transition/slide_right_route.dart';
import 'package:chat/bloc/Info_bloc/info_bloc.dart';
import 'package:chat/Screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../notifications.dart';

class Info extends StatefulWidget {
  Info({this.email, this.roomId, this.edit = false});
  final String roomId, email;
  final bool edit;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String _name, _userImage, _mobileToken;
  InfoBloc infoBloc;
  Notifications notifications;

  @override
  void initState() {
    super.initState();
    infoBloc = InfoBloc();
//
  }

  @override
  void dispose() {
    super.dispose();
    infoBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: <Widget>[
                Container(
                  width: 30.0,
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(


                    icon: Icon(Icons.arrow_back_ios,size: 25.0,color: Colors.black,),
                    onPressed: ()=> Navigator.of(context).pop(),
                    alignment: Alignment.centerRight,



                  ),
                ),

                RawMaterialButton(
                  constraints: BoxConstraints(),
                  onPressed: ()=> Navigator.of(context).pop(),
                    child: Text('Back',style: TextStyle(color: Colors.black,fontSize: 17.0,),textAlign: TextAlign.left,),
                        )

              ],),
          )
        ]

    ),
      backgroundColor: Colors.white,
      body: BlocProvider<InfoBloc>(
        create: (context) => InfoBloc(),
        child: SafeArea(
          child: BlocBuilder<InfoBloc, InfoState>(builder: (context, state) {
            infoBloc = BlocProvider.of<InfoBloc>(context);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.email)
                        .get(),
                    builder: (context, snapshot) {
                      infoBloc.add(InfoInitialEvent(
                          roomId: widget.roomId, email: widget.email));

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        _name = snapshot.data.data()['Name'];
                        _userImage = snapshot.data.data()['userImage'];
                        _mobileToken = snapshot.data.data()['mobileToken'];
                        return Column(
                          children: <Widget>[
                            ImageWidget(
                              networkImage: snapshot.data.data()['userImage'],
                              changePhoto: false,
                              width: 100.0,
                              height: 110.0,
                              firstLetter: snapshot.data.data()['Name'][0],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Text(
                                  snapshot.data.data()['Name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                )),
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.center,
                              child: snapshot.data.data()['bio'] == null
                                  ? null
                                  : Text(
                                      snapshot.data.data()['bio'],
                                      textAlign: TextAlign.left,
                                    ),
                            ),
                            SizedBox(height: 20),
                            FlatButton(
                                onPressed: () {
                                  infoBloc.add(StartConversationEvent(
                                      email: widget.email,
                                      roomId: widget.roomId,
                                      mobileToken: _mobileToken));
                                  Navigator.pushAndRemoveUntil(context, SlideRightRoute(page:ChatScreen(
                                      name: _name,
                                      roomId: widget.roomId,
                                      image: _userImage,
                                      token: _mobileToken,
                                      email: widget.email) ,dx: 1.0,dy: 0.0),(Route<dynamic> route) => false);
                                },
                                color: Colors.blueGrey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.chat_bubble,
                                      size: 20.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      'Chat',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0),
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            FlatButton(
                                color: Colors.blueGrey,
                                onPressed: () {
                                  infoBloc.add(UserBlocEvent(
                                      roomId: widget.roomId,
                                      email: widget.email));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.chat_bubble,
                                      size: 20.0,
                                      color: Colors.redAccent,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Container(
                                      child: infoBloc.userBloc == false
                                          ? Text(
                                              'Block',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 16.0),
                                            )
                                          : Text(
                                              'Unblock',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 16.0),
                                            ),
                                    ),
                                  ],
                                )),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

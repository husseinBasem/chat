import 'package:chat/Component/image.dart';
import 'package:chat/Transition/slide_right_route.dart';
import 'package:chat/bloc/Info_bloc/info_bloc.dart';
import 'package:chat/Screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Info extends StatefulWidget {
  Info({this.email, this.roomId, this.edit = false});
  final String roomId, email;
  final bool edit;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  InfoBloc infoBloc;

  @override
  void initState() {
    super.initState();
    infoBloc = InfoBloc();

  }

  @override
  void dispose() {
    super.dispose();
    infoBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.transparent,
      body: BlocProvider<InfoBloc>(
        create: (context) => InfoBloc(),
        child: SafeArea(
          child: BlocBuilder<InfoBloc, InfoState>(builder: (context, state) {
            infoBloc = BlocProvider.of<InfoBloc>(context);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: <Widget>[
                    Container(
                      width: 30.0,
                      padding: EdgeInsets.all(0.0),
                      child: IconButton(


                        icon: Icon(Icons.arrow_back_ios,size: 25.0,color: Colors.white,),
                        onPressed: ()=> Navigator.of(context).pop(),
                        alignment: Alignment.centerRight,



                      ),
                    ),

                    RawMaterialButton(
                      constraints: BoxConstraints(),
                      onPressed: ()=> Navigator.of(context).pop(),
                      child: Text('Back',style: TextStyle(color: Colors.white,fontSize: 17.0,),textAlign: TextAlign.left,),
                    )

                  ],),

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

                     if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          ImageWidget(
                            networkImage: snapshot.data.data()['userImage'],
                            changePhoto: false,
                            width: 130.0,
                            height: 130.0,
                            firstLetter: snapshot.data.data()['Name'][0],
                            boxShadow: BoxShadow(
                            offset: Offset(0,0),
                                blurRadius: 9.0,
                                spreadRadius: 3.0,
                                color: Colors.grey.withOpacity(0.4),
                            ),

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
                                    fontSize: 20,
                                    color: Colors.white),
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
                                    style: TextStyle(color: Colors.grey),

                                  ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin:EdgeInsets.symmetric(horizontal: 5.0),
                            child: RawMaterialButton(
                                onPressed:infoBloc.userBloc == false?
                                    () {
                                  infoBloc.add(StartConversationEvent(
                                      email: widget.email,
                                      roomId: widget.roomId,
                                      mobileToken: snapshot.data.data()['mobileToken']));
                                  Navigator.pushAndRemoveUntil(context, SlideRightRoute(page:ChatScreen(
                                      name: snapshot.data.data()['Name'],
                                      roomId: widget.roomId,
                                      image: snapshot.data.data()['userImage'],
                                      token: snapshot.data.data()['mobileToken'],
                                      email: widget.email)
                                      ,dx: 1.0,dy: 0.0),(Route<dynamic> route) => false);
                                }:null,
                              fillColor: Colors.white10,

                                child: Container(

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: <Widget>[
                                      Icon(
                                        Icons.chat_bubble,
                                        size: 20.0,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        'Chat',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      )
                                    ],
                                  ),
                                ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin:EdgeInsets.symmetric(horizontal: 5.0),
                            child: FlatButton(
                                color: Colors.white10,

                                onPressed: () {
                                  infoBloc.add(UserBlocEvent(
                                      roomId: widget.roomId,
                                      email: widget.email));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: <Widget>[
                                    Icon(
                                      Icons.block,
                                      size: 20.0,
                                      color: Colors.redAccent,
                                    ),
                                    SizedBox(
                                      width: 5.0,
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
                                ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }


}

import 'package:chat/Transition/slide_right_route.dart';
import 'package:chat/bloc/chat_list_bloc/chat_list_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../chat_id.dart';
import '../Screens/chat_screen.dart';
import 'image.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile(
      {this.receiverEmail,
      this.lastMessage,
      this.messagesUnSeen,
      this.showIcon,
      this.chatListBloc,
      this.time});

  final String receiverEmail, lastMessage,time;
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

          if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {

              return RawMaterialButton(

                onPressed: () {

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
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: 10.0,),


                      CircleAvatar(
                            radius: 25.0,
                            child: ImageWidget(
                              width: 65.0,
                              changePhoto: false,
                              firstLetter: snapshot.data.docs[index].data()['Name'][0],
                              networkImage: snapshot.data.docs[index].data()['userImage'],

                            ),
                          ),

                        SizedBox(
                          width: 20.0,
                        ),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[
                            Text(
                              snapshot.data.docs[index].data()['Name'],
                              style: TextStyle(color: Colors.white,),

                            ),
                              SizedBox(height: 7.0,),
                              Text(
                            lastMessage==null?'':lastMessage,
                                style: TextStyle(color: Colors.white70,height: 1.3),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              ),


                            ],
                          ),
                        ),

                        SizedBox(width: 10.0,),

                        Container(
                          child: messagesUnSeen == 0 || showIcon == true
                              ? null
                              : Column(

                                children: <Widget>[
                                  Padding(
                                    padding:  EdgeInsets.only(right: 5.0),
                                    child: Text('${time.substring(10, 16)}',style: TextStyle(color: Colors.white),),
                                  ),
                                  SizedBox(height: 15.0,),
                                  Material(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    color: Colors.blueAccent,
                                    child: Container(
//                                  width: 25.0,
                                      height: 25.0,
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(vertical: 2.0,horizontal: 7.0),
                                        child: Text(
                                          messagesUnSeen.toString(),
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15.0),
                                        ),
                                      ),
                                      ),
                                  ),
                                ],
                              ),
                        ),



                      ],

                    ),

                    Divider(
//                    height: 20.0,
                      color: Colors.white10,
                      thickness: 1.0,
                      indent: 78.0,
//                    endIndent: 10.0,
                    )


                  ],
                ),
              );





//              return Column(
//                children: <Widget>[
//                  ListTile(
//
//
//                    title: Text(
//                      snapshot.data.docs[index].data()['Name'],
//                      style: TextStyle(color: Colors.white,),
//
//                    ),
//
//
//
//                    subtitle: Text(
//                      lastMessage,
//                      style: TextStyle(color: Colors.white70),
//                      maxLines: 2,
//                    ),
//                    leading: CircleAvatar(
//                      radius: 25.0,
//                      child: ImageWidget(
//                        width: 65.0,
//                        changePhoto: false,
//                        firstLetter: snapshot.data.docs[index].data()['Name'][0],
//                        networkImage: snapshot.data.docs[index].data()['userImage'],
//
//
//                      ),
//                    ),
//
//
//                    trailing: messagesUnSeen == 0 || showIcon == true
//                        ? null
//                        : Column(
//
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text('${time.substring(10, 16)}',style: TextStyle(color: Colors.white),),
//                            Material(
//                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                              color: Colors.white10,
//                              elevation:3.0 ,
//                              child: Container(
////                                  width: 25.0,
//                                height: 25.0,
//                                child: Padding(
//                                  padding:  EdgeInsets.symmetric(vertical: 4.0,horizontal: 7.0),
//                                  child: Text(
////                                    messagesUnSeen.toString()
//                                    '1',
//                                    style: TextStyle(
//                                        color: Colors.white, fontSize: 15.0),
//                                  ),
//                                ),
//                                ),
//                            ),
//                          ],
//                        ),
//                    onTap: () {
//
//                      chatListBloc.add(SwitchToChatScreenEvent(
//                          mobileToken:snapshot.data.docs[index].data()['mobileToken'] ,
//                          roomId:createChatId.getChatID(
//                              FirebaseAuth.instance.currentUser.email,
//                              snapshot.data.docs[index]
//                                  .data()['Email']) ,email:snapshot.data.docs[index]
//                                          .data()['Email'] ));
//
//
//                      chatListBloc.startConversion(
//                          email:snapshot.data.docs[index].data()['Email'],
//                          roomId: createChatId.getChatID(FirebaseAuth.instance.currentUser.email, snapshot.data.docs[index].data()['Email']),
//                          mobileToken: snapshot.data.docs[index].data()['mobileToken']);
//
//                      Navigator.push(context, SlideRightRoute(page: ChatScreen(
//                          name: snapshot.data.docs[index]
//                              .data()['Name'],
//                          roomId: createChatId.getChatID(
//                              FirebaseAuth.instance.currentUser.email,
//                              snapshot.data.docs[index]
//                                  .data()['Email']),
//                          image: snapshot.data.docs[index].data()['userImage'],
//                          token: snapshot.data.docs[index]
//                              .data()['mobileToken'],
//                          email: snapshot.data.docs[index]
//                              .data()['Email']),dx: 1.0,dy: 0.0));
//
//
//
//
//
//                    },
//                  ),
//                  Divider(
//                    height: 0.0,
//                    color: Colors.white10,
//                    thickness: 1.0,
//                    indent: 75.0,
//                    endIndent: 10.0,
//                  )
//                ],
//              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

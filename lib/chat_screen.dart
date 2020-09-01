import 'package:flutter/material.dart';
import 'package:chat/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget{


  _ChatScreenState createState() => _ChatScreenState();


}

class _ChatScreenState extends State<ChatScreen>{
  
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User  LoggedInUser;
  String message;


  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {

    try {
      final user = _auth.currentUser;
      if (user != null) {
        LoggedInUser = user;
        print(LoggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close), onPressed: (){

            _auth.signOut();
            Navigator.pop(context);
          }),

        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,

      ),
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration:kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          onChanged: (value) {
                            message = value;
                            
                          },
                          decoration: kMessageTextFileDecoration,
                        ),
                    ),
                    FlatButton(onPressed: (){
                      _fireStore.collection('text').add({
                        'sender': LoggedInUser.email,
                        'message': message,
                      });
                      
                    }, child: Text('Send',style: kSendButtonTextStyle,),),
                  ],
                ),
              ),

            ],
          )
      ),


    );
  }
  
}
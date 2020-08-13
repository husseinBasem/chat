import 'package:flutter/material.dart';
import 'package:chat/constans.dart';

class ChatScreen extends StatefulWidget{


  _ChatScreenState createState() => _ChatScreenState();


}

class _ChatScreenState extends State<ChatScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close), onPressed: (){}),

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
                          onChanged: (value) {},
                          decoration: kMessageTextFileDecoration,
                        ),
                    ),
                    FlatButton(onPressed: (){}, child: Text('Send',style: kSendButtonTextStyle,),),
                  ],
                ),
              ),

            ],
          )
      ),


    );
  }
  
}
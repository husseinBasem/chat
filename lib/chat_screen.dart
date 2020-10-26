import 'package:flutter/material.dart';
import 'package:chat/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_messaging/firebase_messaging.dart';




final _fireStore = FirebaseFirestore.instance;
User  loggedInUser;





class ChatScreen extends StatefulWidget{

  ChatScreen({this.name,this.roomId,this.image,this.token,this.email});
  final String name;
  final String roomId;
  final String image;
  final String token;
  final String email;

  _ChatScreenState createState() => _ChatScreenState();


}
Map<String, String> messages = {};


class _ChatScreenState extends State<ChatScreen>{
  final messageTextController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _auth = FirebaseAuth.instance;
  String message;
  int numberOFmessagesArenotSeen=1;
  bool block;



  @override
  void initState()  {
    super.initState();
    getCurrentUser();
  //  messagesSeen(widget.roomId);
    chatWith();
    getBlockValue(widget.roomId);
  }

  @override
  void dispose() {
    super.dispose();
     closeScreen();

  }

  void getCurrentUser() {

    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    }catch(e){
      print(e);
    }
  }




  @override
  Widget build(BuildContext context,) {

    return Scaffold(
      
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding:  EdgeInsets.only(right: 5.0),
            child:







            Container(
              height: 20.0,
              width: 35.0,
              child: CircleAvatar(
//                backgroundColor: Colors.black54,
              backgroundImage: widget.image==null?null:NetworkImage(widget.image),
//                radius: 10.0,


//              child:widget.image==null?null:Image.network(widget.image,fit: BoxFit.cover,) ,
//              radius: 20.0,

              ),
            ),
          ),

        ],

        title: Text(widget.name),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,

      ),
      body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {

            return SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.vertical,



              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: <Widget>[
                   Padding(
                     padding:  EdgeInsets.only(bottom: 10.0),
                     child:block ==true?null: MessagesStream(widget.roomId),
                   ),




                    Container(

                      decoration:kMessageContainerDecoration,
                      child:block==false? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Expanded(
                            child: TextField(
                              controller: messageTextController,

                              onChanged: (value) {
                                message = value;
                                print(messageTextController.text);

                              },


                              decoration: kMessageTextFileDecoration,
                            ),
                          ),
                          FlatButton(onPressed: () async{
                            messagePlayLoad(message);
                            messageTextController.clear();

                            addConversationMessages(widget.roomId,message,messages);



                          }, child: Text('Send',style: kSendButtonTextStyle,),),
                        ],
                      ):
                      Container(
                        padding: EdgeInsets.only(bottom: 5.0),
                        color: Colors.red,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Text('You Got Blocked From ${widget.name}',style: TextStyle(height: 2.0,fontSize: 17.0,color: Colors.white),textAlign: TextAlign.center,),

                          ],
                        ),
                      ),
                    ),







                  ]
                ),
              ),
            );
  }
          )
      ),


    );
  }



  addConversationMessages(
      String roomid,message, Map<String, String> messageMap) async {

    List<String> users = [widget.email,  FirebaseAuth.instance.currentUser.email];

    await _fireStore
        .collection("ChatRoom")
        .doc(roomid)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    }
    );
    
    await _fireStore
          .collection('ChatRoom')
          .doc(roomid)
          .update({
      'lastMessage': message,
      'users':users


          });

    messagesArenotSeen(roomid);




  }


  Future<void>messagePlayLoad( String text)async  {
    messages = {
      "message": text,
      "sentBy": FirebaseAuth.instance.currentUser.email,
      "timestamp": DateTime.now().toString(),
      'chattingWith':widget.token,
      'messageFromToken':await _firebaseMessaging.getToken(),
    };

  }

  Future<void> chatWith()async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email).update({
      'chattingWith':widget.token,

    });

  }

  Future<void> getBlockValue(String roomid)async{
      await FirebaseFirestore.instance.collection('ChatRoom').doc(roomid).get()
      .then((value)  {
        block = value.data()[widget.email.replaceAll('.', '_')];


  });
  }

//Future<void> messagesSeen(roomid) async{
//  String sender;
//  int messagesArenotSeen;
//
//  await FirebaseFirestore.instance.collection('ChatRoom').doc(roomid).get()
//      .then((value)  {
//    sender = value.data()['users'][1];
//    messagesArenotSeen = value.data()['messagesArenotSeen'];
//
//  });
//
//
//
//  await _fireStore
//      .collection('ChatRoom')
//      .doc(roomid)
//      .update({'messagesArenotSeen': sender==FirebaseAuth.instance.currentUser.email?messagesArenotSeen:0});
//
//
//}

Future<void> messagesArenotSeen (roomid)async {
  String recevingMessagesEmail,chattingWithToken;

          await _fireStore.collection('ChatRoom').doc(roomid).get()
        .then((value)  {
          recevingMessagesEmail = value.data()['users'][0];
          });

           await _fireStore.collection('users').doc(recevingMessagesEmail).get()
           .then((value)  {
             chattingWithToken = value.data()['chattingWith'];
            });

           print(recevingMessagesEmail);
           print(chattingWithToken);
           print(await _firebaseMessaging.getToken());


        if (chattingWithToken != await _firebaseMessaging.getToken()){
          print('working : $numberOFmessagesArenotSeen');
          await _fireStore
              .collection('ChatRoom')
              .doc(roomid)
              .update({'messagesArenotSeen': numberOFmessagesArenotSeen++});


        }

}

Future<void> closeScreen()async{
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.email).update({
    'chattingWith':null,

  });

}



}



class MessagesStream extends StatelessWidget {
  @override

  MessagesStream(this.roomId);
  final String roomId;
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: getConversationMessages(roomId),

        builder:(context,snapshot){
          if (!snapshot.hasData){
            return Center(
              child:CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ) ,
            );
          }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              reverse: true,

              itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index){
                  final messages = snapshot.data.docs[index];

                  final messageText = messages.data()['message'];
                  final messageSender = messages.data()['sentBy'];
                  final currentUser = loggedInUser.email;
            //      final messageBubble =
                  return MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isMe: currentUser == messageSender,
                  );

                }
            );


        }
    );
  }


  Stream getConversationMessages(String roomid) {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(roomid)
        .collection("chats")
        .orderBy("timestamp", descending: true)
        .snapshots();

  }

}





class MessageBubble extends StatelessWidget {

  MessageBubble({this.text,this.sender,this.isMe});
  final String sender;
  final String text;
  final bool  isMe;


  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding:EdgeInsets.only(bottom: 5.0,right: 3.0,left: 3.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[

          Material(
            borderRadius: isMe
            ? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              topRight:  Radius.circular(20.0),
            )
            :BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(20.0),
            ),
//            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.black54,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:15.0 ),
              child: Container(
                constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width/2 ),



                child: Text(
                  text,

                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color:Colors.white,
                    fontSize: 15.0
                  ),
                    ),
              ),
            ),

          )

        ],
      ),
    );
  }








}

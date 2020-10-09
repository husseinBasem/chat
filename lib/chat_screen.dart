
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chat/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';


final _fireStore = FirebaseFirestore.instance;
User  loggedInUser;





class ChatScreen extends StatefulWidget{

  ChatScreen({this.name,this.roomId,this.image});
  final String name;
  final String roomId;
  final String image;

  _ChatScreenState createState() => _ChatScreenState();


}
Map<String, String> messages = {};


class _ChatScreenState extends State<ChatScreen>{
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String message;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
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
    // TODO: implement build

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
                     child: MessagesStream(widget.roomId),
                   ),




                    Container(

                      decoration:kMessageContainerDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Expanded(
                            child: TextField(
                              controller: messageTextController,

                              onChanged: (value) {
                                message = value;
                                sendddMessageOnline(message);
                                print(messageTextController.text);

                              },


                              decoration: kMessageTextFileDecoration,
                            ),
                          ),
                          FlatButton(onPressed: (){
                            messageTextController.clear();

                            addConversationMessages(widget.roomId,messages);

//                      _fireStore.collection('text').add({
//                        'sender': loggedInUser.email,
//                        'message': message,
//                      });

                          }, child: Text('Send',style: kSendButtonTextStyle,),),
                        ],
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
      String roomid, Map<String, String> messageMap) async {
  //  DocumentReference documentReference =
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(roomid)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }


  sendddMessageOnline( String text) {
    messages = {
      "message": text,
      "sentBy": FirebaseAuth.instance.currentUser.email,
      "timestamp": DateTime.now().toString(),
    };

  }




}



class MessagesStream extends StatelessWidget {
  @override

  MessagesStream(this.roomId);
  final String roomId;
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: getConversationMessages(roomId),
//        _fireStore.collection("ChatRoom")
//            .doc(roomId)
//            .collection("chats").snapshots(),
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

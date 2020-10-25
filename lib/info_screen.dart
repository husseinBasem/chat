import 'dart:io';
import 'package:chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
class Info extends StatefulWidget  {

  Info({this.email,this.roomId,this.mobileToken,this.edit=false});
   final String roomId, email,mobileToken;
   final bool edit;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info > {



  File _image;
  final picker = ImagePicker();
  String imageLink,name,fullName,bio;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    downloadImage();
    getName();
    }



  @override
  Widget build(BuildContext context)  {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: <Widget>[

              SizedBox(height: 60.0,),

              Stack(

                overflow: Overflow.visible,

                alignment: AlignmentDirectional.bottomCenter,

                children: <Widget>[



                  Container(
                    height: 110.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blueAccent,
                    ),
                    child: Container(
                    height:110.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blueAccent,
                    image:imageLink==null?null: DecorationImage(image: NetworkImage(imageLink),fit: BoxFit.cover)
                  ),
                ),

                  ),







                   MaterialButton(

                    onPressed: () async{
                     await getImage();
                     updateUserImage();

                      },
                    color: Colors.blueAccent,
                    height: 25.0,
                    child: Icon(


                      Icons.add,
                      size: 25.0,
                      color: Colors.white,

                    ),
                    shape: CircleBorder(side:BorderSide(color: Colors.white) ),
                  ),














        ],

              ),

              SizedBox(height: 20.0,),

              Container(
                  alignment: Alignment.center,
                  child: Text( fullName==null?'':fullName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),


                  )
              ),

              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Text( bio==null?'':bio,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 20),
              FlatButton(
                  onPressed: (){
                    startConversion(email:widget.email ,roomId:widget.roomId );
                    Navigator.push(context,MaterialPageRoute(builder: ( context) =>ChatScreen(name: name,roomId: widget.roomId,image: imageLink,token: widget.mobileToken,email:widget.email),


                    ), );


                  },
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Icon(Icons.chat_bubble,size: 20.0,color: Colors.white,),
                      SizedBox(width: 10.0,),

                      Text(
                        'Chat',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0)
                        ,)
                    ],
                  )
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.blueGrey,
                onPressed: ()async { String s = await _firebaseMessaging.getToken(); },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Icon(Icons.chat_bubble,size: 20.0,color: Colors.redAccent,),
                    SizedBox(width: 10.0,),

                    Text(
                      'Block',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16.0)
                      ,)
                  ],
                )
              ),






            ],


          ),
        ),
      ),
    );
  }

  creatChatRoom(String roomId, chatRoomMap)async{
    
   await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(roomId)
        .set(chatRoomMap)
        .catchError((onError){
          print(onError);
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email).update({
      'chattingWith':widget.mobileToken

    });
  }

  startConversion({ String email,String roomId }) async {
    String lastMessage,sender;
    int messagesArenotSeen;


    List<String> users = [email, FirebaseAuth.instance.currentUser.email];

    await FirebaseFirestore.instance.collection('ChatRoom').doc(roomId).get()
        .then((value)  {
      lastMessage = value.data()['lastMessage'];
    });

    await FirebaseFirestore.instance.collection('ChatRoom').doc(roomId).get()
        .then((value)  {
      sender = value.data()['users'][1];
    });

    await FirebaseFirestore.instance.collection('ChatRoom').doc(roomId).get()
        .then((value)  {
      messagesArenotSeen = value.data()['messagesArenotSeen'];
    });


    Map<String,dynamic> chatRoomMap = {

      "users" : users,
      "chatRoomId" : roomId,
      "timeStamp" : DateTime.now().toString().toString(),
      'lastMessage':lastMessage,
      'messagesArenotSeen': sender==FirebaseAuth.instance.currentUser.email?messagesArenotSeen:0,
    };

    creatChatRoom(roomId,chatRoomMap);



  }

  Future<void> getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null){
        _image =File(pickedFile.path);
      }
    });
  }

  Future<void> updateUserImage() async{

    StorageReference ref = FirebaseStorage.instance.ref().child('userImages').child('${FirebaseAuth.instance.currentUser.email}.jpg');
    final StorageUploadTask task = ref.putFile(_image);
    var imageUrl = await (await task.onComplete).ref.getDownloadURL();

    FirebaseAuth.instance.currentUser.updateProfile(
      photoURL: imageUrl

    );
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).update(
      {"userImage": imageUrl},
    ).catchError((onError) {
      print(onError);
    });

  }


   Future<void> downloadImage() async {
    await FirebaseFirestore.instance.collection('users').where('Email',isEqualTo: widget.email).get()
         .then((QuerySnapshot querySnapshot) => {
       querySnapshot.docs.forEach((doc) {
         setState(() {
           imageLink =  doc.data()['userImage'].toString().isEmpty?null:doc.data()['userImage'];
           name = doc.data()['Name'];

         });
       })
     });
  }

  Future<void>getName() async{

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.email).get()
        .then((value)
    {
      fullName = value.data()['Name'];
      bio = value.data()['bio'];
    }

    );


}










}



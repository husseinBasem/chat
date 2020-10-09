import 'dart:io';

import 'package:chat/chat_list.dart';
import 'package:chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
class Info extends StatefulWidget  {

  Info({this.email,this.roomId});
   final String roomId, email;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info > {



  File _image;
  final picker = ImagePicker();
  String imageLink,name;


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    downloadImage();
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
                   //   image: DecorationImage(image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/chat-6b9bc.appspot.com/o/userImages%2Ftest1%40gmail.com.jpg?alt=media&token=a23d07c7-ea4b-4cba-acae-65e1751145f1'),fit: BoxFit.cover,),
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
                  child: Text( 'Hussein Basem',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),


                  )
              ),

              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Text( 'UI/UX Designer at GTBank & Creative Director at PxDsgn Co. Creating simple digital products over. Let’s talk designs via\n email: sgnco@gmail.com',
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 20),
              FlatButton(
                  onPressed: (){
                    startConversion(email:widget.email ,roomId:widget.roomId );
                    Navigator.push(context,MaterialPageRoute(builder: ( context) =>ChatScreen(name: name,roomId: widget.roomId,image: imageLink,),

//                            (Route<dynamic> route) => false)

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
                onPressed: () { print(name); },
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

  creatChatRoom(String roomId, chatRoomMap){
    
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(roomId)
        .set(chatRoomMap)
        .catchError((onError){
          print(onError);
    });
  }

  startConversion({ String email,String roomId })  {

    List<String> users = [email, FirebaseAuth.instance.currentUser.email];


    Map<String,dynamic> chatRoomMap = {

      "users" : users,
      "chatRoomId" : roomId,
      "timeStamp" : DateTime.now().toString().toString(),
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


   void downloadImage()  {
     FirebaseFirestore.instance.collection('users').where('Email',isEqualTo: widget.email).get()
         .then((QuerySnapshot querySnapshot) => {
       querySnapshot.docs.forEach((doc) {
         setState(() {
           imageLink =  doc.data()['userImage'];
           name = doc.data()['Name'];

         });
       })
     });
  }







}


